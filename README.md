# aws-ecs-ha-app

This is a repository for my personal project of setting up a high availability application on AWS ECS Fargate.(I haven't decided on which application yet, I was going to used bookstack then I discovered that It would be problematic to scale, due to the fact that all storage is stored on the disk, without an option for external storage)

The following AWS technologies will be used.
- ECS (Fargate)
- ALB
- RDS
- AWS CDK (Cloud Development Kit)
