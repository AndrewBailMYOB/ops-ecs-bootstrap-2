.DEFAULT_GOAL := help
SHELL         := /bin/bash

KEYNAME  := ops-ecs-key
STACKNET := ops-ecs-network
STACKECS := ops-ecs-cluster
P_REGION := ap-southeast-2
T_REGION := us-west-2

.PHONY: help stack delete test delete-test test-scripts

stack:
	@echo "--- :checkered_flag: Building stack"; \
	export AWS_DEFAULT_REGION=$(P_REGION) && \
	echo "--- :key: Creating keypair" && \
	./scripts/create-keypair.sh $(KEYNAME) && \
	echo "--- :cloudformation: Building network stack" && \
	./scripts/create-stack.sh $(STACKNET) network/template.yml network/params.json && \
	echo "--- :cloudformation: Building ECS cluster stack" && \
	./scripts/create-stack.sh $(STACKECS) ecs-cluster/template.yml ecs-cluster/params.json && \
	echo "--- :trophy: Stack built!"

delete:
	@echo "--- :gun: Deleting stack"; \
	export AWS_DEFAULT_REGION=$(P_REGION) && \
	echo "--- :key: Deleting keypair" && \
	aws ec2 delete-key-pair --key-name $(KEYNAME) && \
	rm -f $(KEYNAME).pem && \
	echo "--- :cloudformation: Deleting ECS cluster stack" && \
	aws cloudformation delete-stack --stack-name $(STACKECS) && \
	aws cloudformation wait stack-delete-complete --stack-name $(STACKECS) && \
	echo "--- :cloudformation: Deleting network stack" && \
	aws cloudformation delete-stack --stack-name $(STACKNET) && \
	aws cloudformation wait stack-delete-complete --stack-name $(STACKNET) && \
	echo "--- :trophy: Stack deleted!"

test: test-scripts
	@echo "--- :checkered_flag: Building test stack"; \
	export AWS_DEFAULT_REGION=$(T_REGION) && \
	echo "--- :key: Creating keypair" && \
	./scripts/create-keypair.sh $(KEYNAME) && \
	echo "--- :cloudformation: Building network stack" && \
	./scripts/create-stack.sh $(STACKNET) network/template.yml network/params_test.json && \
	echo "--- :cloudformation: Building ECS cluster stack" && \
	./scripts/create-stack.sh $(STACKECS) ecs-cluster/template.yml ecs-cluster/params_test.json && \
	echo "--- :trophy: Test stack built!"

test-scripts:
	@echo '--- :bash: Testing scripts'
	docker run -v "$(PWD):/mnt" koalaman/shellcheck scripts/*.sh

delete-test:
	@echo "--- :gun: Deleting test stack"; \
	export AWS_DEFAULT_REGION=$(T_REGION) && \
	echo "--- :key: Deleting keypair" && \
	aws ec2 delete-key-pair --key-name $(KEYNAME) && \
	rm -f $(KEYNAME).pem && \
	echo "--- :cloudformation: Deleting ECS cluster stack" && \
	aws cloudformation delete-stack --stack-name $(STACKECS) && \
	aws cloudformation wait stack-delete-complete --stack-name $(STACKECS) && \
	echo "--- :cloudformation: Deleting network stack" && \
	aws cloudformation delete-stack --stack-name $(STACKNET) && \
	aws cloudformation wait stack-delete-complete --stack-name $(STACKNET) && \
	echo "--- :trophy: Test stack deleted!"

help:
	@echo ''
	@echo '-------------------------------------------------------'
	@echo "Orlando's Amazing Stack Buildy Thing!"
	@echo '-------------------------------------------------------'
	@echo ''
	@echo 'To execute against $(P_REGION): make stack'
	@echo ''
	@echo 'The templates that will be submitted for execution are:'
	@echo 'network/template.yml'
	@echo 'ecs-cluster/template.yml'
	@echo ''
	@echo 'In that order; there are output dependencies.'
	@echo 'You can find the parameters in those directories.'
	@echo ''
	@echo 'To test the stack, execute: make test'
	@echo 'This will build out a test stack in $(T_REGION).'
	@echo 'To tear-down the test stack: make delete-test'
	@echo ''
	@echo 'Enjoy this fine aguardiente con moderación.'
	@echo '-------------------------------------------------------'
	@echo ''
