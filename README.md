# ops-cloudformation

[![Build status](https://badge.buildkite.com/7842a01eaebc926427faf465582eb823d14f3a4b32245fc5c1.svg)](https://buildkite.com/myob/ops-cloudformation)

A collection of AWS CloudFormation stacks to create resources on demand.


## Deploying a stack
The default action for the supplied `Makefile` is to provision a full network
and ECS cluster stack.

A script is provided for executing individual CloudFormation templates.

If a stack already exists (by name), the stack will be updated rather than
created.


## Examples

### Get help
```bash
make help
```


### Build out the default network stack
```bash
make stack
```
This will build out a full network and ECS stack to `ap-southeast-2`.


### Build out a test stack
```bash
make test
```
This will deploy full network and ECS stacks to `us-west-2`.


### Deploy a template
```bash
./scripts/deploy_stack.sh [stackname] [template path] [param file path]
```
Deploy a single template to your current account and region.


## Bundled Stacks
Some default stacks are provided; see the following for further information:

* [Base network](network/)
* [ECR](ecr/)
* [ECS-Cluster](ecs-cluster/)
