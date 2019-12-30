# aws-ecs-ha-app

This is a repository for my personal project of setting up high availability 'hello-world' application on AWS Fargate with terraform, using a GitLab CI/CD pipeline for deployment.

A rough diagram of the infrastructure is below.
![Application Diagram](img/aws_vpc_diagram.png)

A rough diagram of the CI/CD pipeline is below.
![CI/CD Diagram](img/ci_cd_pipeline_aws_ecs_ha_app.png)

the docker image for this application is [here](https://hub.docker.com/r/joelfreeman/aws-ecs-app).