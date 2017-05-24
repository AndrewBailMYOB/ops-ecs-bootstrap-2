.DEFAULT_GOAL      := help
SHELL              := /bin/bash
STACK_NAME         ?= service-stack
AWS_DEFAULT_REGION ?= ap-southeast-2

.PHONY:	help stack delete test

stack:
	@export AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION); \
	./scripts/deploy_stack.sh $(STACK_NAME) network/template.yml network/params.json && \
	./scripts/deploy_stack.sh $(STACK_NAME)-ecs ecs-cluster/template.yml ecs-cluster/params.json

delete:
	#aws cloudformation	delete-stack \
	#	--stack-name $(STACK_NAME)
	#@echo "Waiting for stack deletion to complete ..."
	#aws cloudformation wait stack-delete-complete --stack-name $(STACK_NAME)
	@echo 'not implemented :('

test:
	shellcheck scripts/*.sh

help:
	@echo ""
	@echo "-------------------------------------------------------"
	@echo "Orlando's Amazing Stack Buildy Thing!"
	@echo "-------------------------------------------------------"
	@echo ""
	@echo "To execute with the defaults: make stack"
	@echo ""
	@echo "The possible variables (default in parens) are:"
	@echo "STACK_NAME (service-stack)"
	@echo "AWS_DEFAULT_REGION (ap-southeast-2)"
	@echo ""
	@echo "The variables can be set as environment vars:"
	@echo "STACK_NAME=mystack make stack"
	@echo ""
	@echo "The templates that will be submitted for execution are:"
	@echo "network/template.yml"
	@echo "ecs-cluster/template.yml"
	@echo ""
	@echo "In that order; there are output dependencies."
	@echo "You can find the parameters in those directories."
	@echo ""
	@echo "Enjoy this fine aguardiente con moderación."
	@echo "-------------------------------------------------------"
	@echo ""
