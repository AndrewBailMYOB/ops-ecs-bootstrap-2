# ops-cloudformation
A collection of AWS CloudFormation stacks to create resources on demand.


## Deploying a stack
We are using a [makeFile](Makefile) to execute the deployment. The makefile's
*buildStack* target uses a [Bash script](scripts/deploy_stack.sh) to interact
with `aws cli` to bring up or update a stack. Feedback is provided by the
script to stdout.

If a stack already exists (by name), the stack will be updated rather than
created.


## Examples
* Get help:

`make help`

* Build out the default network stack:

`make buildStack STACK_NAME=foo CFN_LOCATION=network/template.yml CFN_PARAMS=network/params.json`

* Optionally supply a region:

`make buildStack STACK_NAME=foo CFN_LOCATION=network/template.yml CFN_PARAMS=network/params.json DEFAULT_REGION=us-west-2`

* Delete a stack:

`make deleteStack STACK_NAME=foo DEFAULT_REGION=us-west-2`

## Bundled Stacks
Some default stacks are provided; see the following for further information:

* [Base network](network/)
* [ECR](ecr/)
* [ECS-Cluster](ecs-cluster/)
