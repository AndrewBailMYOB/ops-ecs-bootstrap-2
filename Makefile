.DEFAULT_GOAL := help
SHELL         := /bin/bash

KEYNAME  := service-stack-key
STACKNET := service-stack-net
STACKECS := service-stack-ecs
P_REGION := ap-southeast-2
T_REGION := us-west-2

.PHONY: help stack delete test delete-test

stack:
	@export AWS_DEFAULT_REGION=$(P_REGION); \
	./scripts/create_keypair.sh $(KEYNAME) && \
	./scripts/deploy_stack.sh $(STACKNET) network/template.yml network/params.json && \
	./scripts/deploy_stack.sh $(STACKECS) ecs-cluster/template.yml ecs-cluster/params.json
	@echo ":cloudformation: :trophy:"

delete:
	#aws cloudformation delete-stack \
	#	--stack-name $(STACK_NAME)
	#@echo "Waiting for stack deletion to complete ..."
	#aws cloudformation wait stack-delete-complete --stack-name $(STACK_NAME)
	@echo 'not implemented :('

test:
	shellcheck scripts/*.sh
	export AWS_DEFAULT_REGION=$(T_REGION); \
	./scripts/create_keypair.sh $(KEYNAME) && \
	./scripts/deploy_stack.sh $(STACKNET) network/template.yml network/params_test.json && \
	./scripts/deploy_stack.sh $(STACKECS) ecs-cluster/template.yml ecs-cluster/params_test.json
	@echo ":cloudformation: :trophy:"

delete-test:
	export AWS_DEFAULT_REGION=$(T_REGION); \
	aws ec2 delete-key-pair --key-name $(KEYNAME) && \
	rm $(KEYNAME).pem && \
	aws cloudformation delete-stack --stack-name $(STACKECS) && \
	aws cloudformation wait stack-delete-complete --stack-name $(STACKECS) && \
	aws cloudformation delete-stack --stack-name $(STACKNET) && \
	aws cloudformation wait stack-delete-complete --stack-name $(STACKNET)

help:
	@echo ''
	@echo '-------------------------------------------------------'
	@echo 'Orlando's Amazing Stack Buildy Thing!'
	@echo '-------------------------------------------------------'
	@echo ''
	@echo 'To execute against ap-southeast-2: make stack'
	@echo ''
	@echo 'The templates that will be submitted for execution are:'
	@echo 'network/template.yml'
	@echo 'ecs-cluster/template.yml'
	@echo ''
	@echo 'In that order; there are output dependencies.'
	@echo 'You can find the parameters in those directories.'
	@echo ''
	@echo 'Enjoy this fine aguardiente con moderación.'
	@echo '-------------------------------------------------------'
	@echo ''
