# ops-cloudformation

A collection of Aws stacks to create resources on demand.

## Deploying a stack

  We are using a [makeFile](Makefile) to execute the deployment, the makefile target uses a [bash script](scripts/deploy_stack.sh) to interact with the aws cli and give feedback on how the stack creation/update is going.

  A stack gets automatically updated if it exists.

  Here are some examples:

  - You can see the makefile targets or use the help command to see an example

  ```
    make help
  ```

  - for a specific example this is how you build the network stack  :

  ```
    make buildStack STACK_NAME=foo CFN_LOCATION=network/template.yml CFN_PARAMS=network/params.json
  ```

  - (Optional) you can specify the region where you want to create or update the stack  

  ```
    make buildStack STACK_NAME=foo CFN_LOCATION=network/template.yml CFN_PARAMS=network/params.json DEFAULT_REGION=us-west-2
  ```

  - Delete a stack, you can also specify the region

  ```
    make deleteStack STACK_NAME=foo DEFAULT_REGION=us-west-2
  ```

These are the stacks we support, click on the link to see more information:

  - [network](network/)
  - [ecr](ecr/)
  - [Ecs-Cluster](ecs-cluster/)
