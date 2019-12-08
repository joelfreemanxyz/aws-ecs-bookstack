# aws-ecs-bookstack

This is a repository for my personal project of setting up a high availability application (In this case, [Bookstack](https://github.com/BookStackApp/BookStack)) on AWS Fargate.

The following AWS technologies will be used.
- ECS (Fargate)
- ALB
- RDS
- AWS CDK (Cloud Development Kit)

I will most likely write my own Dockerfile for Bookstack (or edit an existing Image) as putting it behind a reverse proxy would make it a pain to load balance using an ELB, since the existing image configures it without any Certificates.