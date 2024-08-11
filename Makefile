
# EC2 and Application Load Balancer Deployment
PHONY: plan/ec2alb
plan/ec2alb: # Planning EC2 with Application Load Balancer
plan/ec2alb: 
		cd ec2-alb && terraform init && terraform plan

PHONY: apply/ec2alb
apply/ec2alb: # Deploying EC2 with Application Load Balancer
apply/ec2alb: 
		cd ec2-alb && terraform init && terraform apply --auto-approve

PHONY: destroy/ec2alb
destroy/ec2alb: # Destroying EC2 with Application Load Balancer
destroy/ec2alb: 
		cd ec2-alb && terraform init && terraform destroy --auto-approve


# EKS Deployment
PHONY: plan/eks
plan/eks: # Planning EKS Deployment
plan/eks: 
		cd aws-eks && terraform init && terraform plan

PHONY: apply/eks
apply/eks: # Applying EKS Deployment
apply/eks: 
		cd aws-eks && terraform init && terraform apply --auto-approve

PHONY: destroy/eks
destroy/eks: # Destroying EKS Deployment
destroy/eks: 
		cd aws-eks && terraform init && terraform destroy --auto-approve

# ECR Deployment 
PHONY: plan/ecr
plan/ecr: # Planning ECR Deployment
plan/ecr: 
		cd aws-ecr && terraform init && terraform plan

PHONY: apply/ecr
apply/ecr: # Applying ECR Deployment
apply/ecr: 
		cd aws-ecr && terraform init && terraform apply --auto-approve

PHONY: destroy/ecr
destroy/ecr: # Destroying ECR Deployment
destroy/ecr: 
		cd aws-ecr && terraform init && terraform destroy --auto-approve


# ECS Deployment
PHONY: plan/ecs
plan/ecs: # Planning ECS Deployment
plan/ecs: 
		cd aws-ecs && terraform init && terraform plan

PHONY: apply/ecs
apply/ecs: # Applying ECS Deployment
apply/ecs: 
		cd aws-ecs && terraform init && terraform apply --auto-approve

PHONY: destroy/ecs
destroy/ecs: # Destroying ECS Deployment
destroy/ecs: 
		cd aws-ecs && terraform init && terraform destroy --auto-approve



# Build Docker Image

PHONY: build
build: # Build Image
build: 
		cd myjsapp && docker build -t ${{ env.ECR_REPO_URL }}:$IMAGE_TAG .

PHONY: push
push: # Push Docker Image
push: 
		docker push ${{ env.ECR_REPO_URL }}:$IMAGE_TAG

PHONY: printimagedetails
printimagedetails: # Print Docker Image Details
printimagedetails: 
		echo "Image pushed to: ${{ env.ECR_REPO_URL }}:$IMAGE_TAG"


