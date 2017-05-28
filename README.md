# PE Container Run-time Foundation (ECS)

This repository contains a number of CloudFormation templates and helper
scripts designed to create foundation stacks for running Docker containers
in AWS ECS.


## Infrastructure Deployed

The templates deploy the following infrastructure:


### VPC

One VPC with three subnets across three availability zones.

By default, the VPC encompasses `192.168.0.0/16` and 3 *tiered* subnets.
Each subnet is set to `/20` and each tier is addressable as `/18`.


```
                     +--------------------+--------------------+--------------------+
    TIER MASK        |        AZ1         |        AZ2         |       AZ3          |       SPARE
---------------------------------------------------------------------------------------------------------
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
                     |                    |                    |                    |
                     +--------------------+--------------------+--------------------+
```


### ECS Cluster

An ECS cluster which defines default values for:

* the instance type for the Docker hosts
* the AMI for the Docker hosts
* the Auto-scaling Group

A default role for the `ec2` instances is defined and provided with a basic
policy for accessing internal resources.


## Deploying the Stacks

A [makefile](Makefile) is provided which simplifies deployment. Prior to deployment,
the existence of an SSH keypair is checked for. The keypair name is:
```
ops-ecs-key
```

Stacks are deployed to AWS using a script: (create-stack.sh)[scripts/create-stack.sh].


## EC2 SSH Keypair
If this key does not exist in the account for the region, it will be created
and the private key material is emitted to a local `pem` file. Ensure this
material is captured, saved, and the original file removed securely.

The script which creates the keypair is (create-keypair.sh)[scripts/create-keypair.sh].


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

#### deploy production stacks
```
make stack
```
