# aws-terraform-autobot
Deploy AWS test environments

All test environment are listed below:

ec2-alb -> Deploys a EC2 behind a application Load Balancer
    - Also Deploys a VPC, Subnets, security groups

aws-eks -> Deploys a EKS cluster and node groups the cluster is using an old version of kubernetes
           Need to be upgraded and you can use it to test apps or whatever

aws-ecr -> Deploys a container registry that github builds the images and pushes docker images to it 
           using the docker image in the myjsapp folder

aws-ecs -> Deploys a ECS cluster with a task definition using an apaches docker image

