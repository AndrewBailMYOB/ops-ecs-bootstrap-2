# Don't Panic: ECS Bootstrap Tooling

[![Build status](https://badge.buildkite.com/7842a01eaebc926427faf465582eb823d14f3a4b32245fc5c1.svg)](https://buildkite.com/myob/ops-cloudformation)

This repository contains a number of CloudFormation templates and helper
scripts designed to create foundation stacks for running Docker containers
in AWS ECS.

In order to deploy an application to this set of stacks a test application
is available to use as a base:

[ops-ecs-testapp](https://github.com/MYOB-Technology/ops-ecs-testapp)


## Environments

The two environments (test and production) are separated by region;
production stacks are deployed to `ap-southeast-2`; test stacks are executed
in `us-west-2`. This is because the names and exports of the stacks are fixed.

There are certain resources which span regions, such as `IAM` roles - these
resources are named such that the region is included.


## Infrastructure Deployed

The templates deploy the following infrastructure:


### VPC

One VPC with three subnets across three availability zones.

By default, the VPC encompasses `192.168.0.0/16` and 3 *tiered* subnets.
Each subnet is set to `/20` and each tier is addressable as `/18`.


```
                     +--------------------+--------------------+--------------------+
    TIER MASK        |        AZ1         |        AZ2         |       AZ3          |       SPARE
---------------------+--------------------+--------------------+--------------------+-------------------
                     | +----------------+ | +----------------+ | +----------------+ |
  192.168.0.0/18     | |192.168.0.0/20  | | |192.168.16.0/20 | | |192.168.32.0/20 | |  192.168.48.0/20
                     | +----------------+ | +----------------+ | +----------------+ |
                     |                    |                    |                    |
                     | +----------------+ | +----------------+ | +----------------+ |
 192.168.64.0/18     | |192.168.64.0/20 | | |192.168.80.0/20 | | |192.168.96.0/20 | |  192.168.112.0/20
                     | +----------------+ | +----------------+ | +----------------+ |
                     |                    |                    |                    |
                     | +----------------+ | +----------------+ | +----------------+ |
192.168.128.0/18     | |192.168.128.0/20| | |192.168.144.0/20| | |192.168.160.0/20| |  192.168.176.0/20
                     | +----------------+ | +----------------+ | +----------------+ |
                     +--------------------+--------------------+--------------------+
```

The observant reader will note that there is also a spare tier which could
be provisioned for secure assets or the like.


### ECS Cluster

An ECS cluster which defines default values for:

* the instance type for the Docker hosts
* the AMI for the Docker hosts
* the Auto-scaling Group

A default role for the `ec2` instances is defined and provided with a basic
policy for accessing internal resources.

Instances are configured to automatically drain connections before scaling
events remove instances from the cluster. For further details, see:
[https://aws.amazon.com/blogs/compute/how-to-automate-container-instance-draining-in-amazon-ecs/](https://aws.amazon.com/blogs/compute/how-to-automate-container-instance-draining-in-amazon-ecs/).

## Deploying the Stacks

A [makefile](Makefile) is provided which simplifies deployment. Prior to deployment,
the existence of an SSH keypair is checked for. The keypair name is: `ops-ecs-key`.

Stacks are deployed to AWS using a script: [create-stack.sh](scripts/create-stack.sh).

The script accepts the following:

* stack name
* template path
* parameter file path

The provided makefile sets some default values and then calls the script in order
to deploy the following stacks:

* network (ops-ecs-network)
* ECS cluster (ops-ecs-cluster)


## EC2 SSH Keypair
If this key does not exist in the account for the region, it will be created
and the private key material emitted to a local `pem` file. Ensure this
material is captured, saved, and the original file removed securely.

The script which creates the keypair is [create-keypair.sh](scripts/create-keypair.sh).


### Deployment examples:

#### get help
```
make help
```

#### testing the stacks
```
make test
```
The test stacks will be built into the `us-west-2` region. Once verified,
delete the test stacks:
```
make delete-test
```

There is a step in the makefile which performs a static code analysis of
any shell scripts located in the `scripts` directory. The remainder of
the testing is *smoke* or *pre-flight* style testing as the stacks will be
brought up in a live, production-like environment.

#### deploy production stacks
```
make stack
```

Once executed, the stacks are deployed to the production region. Once again,
ensure that the key material (`ops-ecs-key.pem`) is saved to an appropriate
location and the file removed.


## Service Image

The supplied [Dockerfile](Dockerfile) is used to build an image that is
stored in Artifactory and contains a template for a service definition and
the supporting resources. This image should be pulled by a service creator
and used to create or update a service stack.

Further infomation for using this image is available in the
[test app](https://github.com/MYOB-Technology/ops-ecs-testapp) repository.

The image bundles the template in [ecs-service](ecs-service/) and
the [create-stack.sh](scripts/create-stack.sh) script into a Docker
container and uploads it to Artifactory.  This is achieved via a
[script](scripts/push-image.sh).
