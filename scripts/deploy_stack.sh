#!/bin/bash

stackName=$1
stackTemplateFile=$2
stackParamsFile=$3

log () {
  date "+%Y-%m-%d %H:%M:%S $1"
}

die () {
  echo "FATAL: $1"
  exit 1
}

wait_completion () {
  local stackName=$1
  echo -n "Waiting for stack $stackName to complete:"
  while true; do
    local status=$( aws cloudformation describe-stack-events \
        --stack-name $stackName \
        --query 'StackEvents[].{x: ResourceStatus, y: ResourceType}' \
        --output text | \
        grep "AWS::CloudFormation::Stack" | head -n 1 | awk '{ print $1 }'
      )
      case $status in
        UPDATE_COMPLETE_CLEANUP_IN_PROGRESS)    : ;;
        UPDATE_COMPLETE|CREATE_COMPLETE)
          echo "stack $stackName complete"
          return 0 ;;
        *ROLLBACK*)
          echo "stack $stackName rolling back"
          return 1 ;;
        *FAILED*)
          echo "ERROR creating or updating stack"
          return 1 ;;
        "")
          echo "No output while looking for stack completion"
          return 1 ;;
        *) : ;;
      esac
      echo -n "."
      sleep 5
  done
}

aws_stack () {
  local action=$1
  local stackName=$2
  local stackTemplateFile=$3
  local stackParamsFile=$4

  log "$action $stackName"

  aws cloudformation $action \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --stack-name $stackName \
    --template-body ${stackTemplateFile} \
    --parameters ${stackParamsFile} > /dev/null

  wait_completion $stackName || return 1
}

#Create or update the stack
if [ -z "$( aws cloudformation describe-stacks --stack-name $stackName 2>/dev/null )" ]; then
  action="create-stack --disable-rollback"
else
  action="update-stack"
fi

aws_stack "$action" "$stackName" "$stackTemplateFile" "$stackParamsFile" || die "Can't update stack"

log "Complete"
