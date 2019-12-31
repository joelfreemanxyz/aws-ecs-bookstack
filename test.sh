#!/bin/bash

BRUH=5
echo $BRUH
sudo docker tag bruh "joelfreeman/aws-ecs-app:$(echo $BRUH)"

