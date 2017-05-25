#!/bin/bash
stack_name="$1"
if [[ "$stack_name" == "" ]]; then
    echo "usage: $0 [stack name]"
    echo "creates a keypair called [stack name] and"
    echo "a local file called [stack name].pem"
    echo "if the keyname already exists, does nothing"
    exit 1
fi

die() { echo "ERROR: $*"; exit 1; }

if aws ec2 describe-key-pairs --query 'KeyPairs[*].[KeyName]' --output text | grep "$stack_name" >/dev/null; then
    exit 0
fi

aws ec2 create-key-pair --key-name "$stack_name" --query 'KeyMaterial' --output text >"${stack_name}.pem" || die "unable to create key \"$stack_name\""
