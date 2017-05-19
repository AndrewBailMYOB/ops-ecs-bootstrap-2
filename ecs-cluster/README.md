## Ecs Cluster Stack

This stack will allow teams to create a cluster to host their applications, it does not create the task definition or the ecs service as that is considered particular to the applications teams will run, hence such services will be created in a separate stack

This is an overview of what this stack will create, it provides outputs that can be imported by other cloudformation stacks (like the service and task definition).

```
+------------------------+
|                        |
|     ECS Cluster        |
|                        |
+-----------+------------+
            |
            |
            |                       +-----------------------+              +---------------------+
            |                       |                       |              |                     |
            +-----------------------+  Launch Configuration | <------------+  ECS-Optimized AMI  |
                                    +---------+-------------+              +---------------------+
                                              |
                                              |
                                    +---------+-------------+
                                    |                       |
                                    |   Auto Scaling Group  |
                                    +---------+-------------+
                                              |
                                              |
                                    +---------v-------------+
                                    |   Ec2 Instance        |
                                    |                       |
                                    +-----------------------+
```

This stack will provide scaling policies (wip) to help manage the load, such policies are yet to be determined by the platform team based on our findings while rolling it out to the rest of the delivery teams.
