# ECS Stack
This stack creates a base ECS structure which can be built upon.

Task definitions and ECS services are not created as these comopnents are
specific to an application. These should be managed in a different stack.

See below for a logical diagram of what is created:
```

+-------------+
| ECS Cluster |
+------+------+
       |
       |
       |        +-----------------------+     +---------------------+
       +------->| Launch Configuration  |<----|  ECS-Optimized AMI  |
                +----------+------------+     +---------------------+
                           |
                           |
                +----------+------------+
                |   Auto Scaling Group  |
                +----------+------------+
                           |
                           |
                +----------+------------+
                |     EC2 Instance      |
                +-----------------------+
```

Outputs are defined which may be used in other stacks.

The stack defines a basic scaling policy (WIP).
