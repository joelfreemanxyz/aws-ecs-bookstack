# aws-ecs-ha-app

This is a repository for my personal project of setting up a high availability web application on AWS ECS Fargate.

As far as applications go, I will be using WikiJS. I was going to used Bookstack then I discovered that It could be problematic to scale, due to the fact that all storage is stored on the disk, without an option for external storage. WikiJS is Similar to Bookstack in some ways, but not how content is stored.
By default, content is stored in a database. However, there are other options. These include:
- Using a git repository as a storage location
- Using Amazon S3
And many more.


The following AWS technologies will be used.
- ECS (Fargate)
- ALB
- RDS
