#!/bin/bash

usage() {
    echo "usage: $0 [stack_name] [template_file_path] [params_file_path]"
    exit 0
}

log () {
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "$ts $*"
}

die () {
  echo "FATAL: $*" >&2
  exit 1
}

: "${AWS_DEFAULT_REGION?Export AWS_DEFAULT_REGION and try again}"

[[ "$#" == "3" ]] || usage

hash aws 2>/dev/null || { echo "Error: missing 'awscli' dependency."; exit 2; }

stack_name="$1"
stack_tmpl="$2"
stack_params="$3"
poll_timeout=5

# NOTE: this isn't quite the same as AWS' check, but it's close
[[ "$stack_name" =~ [^-a-zA-Z0-9] ]] && die "bad stack name"

[[ -f $stack_tmpl ]]   || die "template is not a file"
[[ -f $stack_params ]] || die "params is not a file"

get_filesize() { wc -c <"$1"; }
[[ $(get_filesize $stack_tmpl) -gt "0" ]]     || die "template is zero bytes"
[[ $(get_filesize $stack_tmpl) -lt "51200" ]] || die "template is too big"
[[ $(get_filesize $stack_params) -gt "0" ]]   || die "params file is zero bytes"

# polls aws for stack status
wait_completion() {
    local stack_name="$1"
    echo -n "Waiting for \"$stack_name\":"
    while true; do
        local status=$(aws cloudformation describe-stack-events \
            --stack-name $stack_name \
            --query 'StackEvents[].{x: ResourceStatus, y: ResourceType}' \
            --output text | \
            grep "AWS::CloudFormation::Stack" | head -n 1 | awk '{ print $1 }'
        )
        case "$status" in
            UPDATE_COMPLETE_CLEANUP_IN_PROGRESS)
                ;;
            UPDATE_COMPLETE|CREATE_COMPLETE)
                echo "."
                echo "Complete"
                return 0
                ;;
            *ROLLBACK*)
                echo "."
                echo "Rolling back"
                return 1
                ;;
            *FAILED*)
                echo "."
                echo "FAILED"
                return 1
                ;;
            "")
                echo "."
                echo "NO OUTPUT"
                return 1
                ;;
            *)
                ;;
        esac
        echo -n "."
        sleep $poll_timeout
    done
}

# creates or updates a stack
stack_ctl() {
    local action="$1"
    log "name=$stack_name action=$action"

    aws cloudformation $action \
        --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
        --stack-name $stack_name \
        --template-body file://$stack_tmpl \
        --parameters file://$stack_params >/dev/null

    wait_completion $stack_name || return 1
}

# validate the template first
aws cloudformation validate-template --template-body file://$stack_tmpl >/dev/null 2>&1 || die "invalid template"

action="create-stack --disable-rollback"
while read -r; do
    [[ "$REPLY" == "$stack_name" ]] && { action="update-stack"; break; }
done < <(aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text)

stack_ctl "$action" || die "something went wrong :("

log "Complete: name=$stack_name action=$action"
