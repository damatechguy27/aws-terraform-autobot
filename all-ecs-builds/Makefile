#command to edit and run
#terraform plan -var="aws_profile=dev" -var="aws_region=us-east-1" -var="env=dev"

# Prod ECR Deployment 
PHONY: plan/prod-ecr
plan/ecr: # Planning ECR Deployment
plan/ecr: 
		cd aws-ecr && terraform init && terraform plan -var="env=Prod"

PHONY: apply/prod-ecr
apply/ecr: # Applying ECR Deployment
apply/ecr: 
		cd aws-ecr && terraform init && terraform apply --auto-approve -var="env=Prod"

PHONY: destroy/prod-ecr
destroy/ecr: # Destroying ECR Deployment
destroy/ecr: 
		cd aws-ecr && terraform init && terraform destroy --auto-approve -var="env=Prod"

# Dev ECR Deployment
PHONY: plan/dev-ecr
plan/ecr: # Planning ECR Deployment
plan/ecr: 
		cd aws-ecr && terraform init && terraform plan -var="env=Dev"

PHONY: apply/dev-ecr
apply/ecr: # Applying ECR Deployment
apply/ecr: 
		cd aws-ecr && terraform init && terraform apply --auto-approve -var="env=Dev"

PHONY: destroy/dev-ecr
destroy/ecr: # Destroying ECR Deployment
destroy/ecr: 
		cd aws-ecr && terraform init && terraform destroy --auto-approve -var="env=Dev"

# Prod ECS Deployment
PHONY: plan/ecs
plan/ecs: # Planning ECS Deployment
plan/ecs: 
		cd aws-ecs && terraform init && terraform plan -var="env=Prod"

PHONY: apply/ecs
apply/ecs: # Applying ECS Deployment
apply/ecs: 
		cd aws-ecs && terraform init && terraform apply --auto-approve -var="env=Prod"

PHONY: destroy/ecs
destroy/ecs: # Destroying ECS Deployment
destroy/ecs: 
		cd aws-ecs && terraform init && terraform destroy --auto-approve -var="env=Prod"


# Dev ECS Deployment
PHONY: plan/ecs
plan/ecs: # Planning ECS Deployment
plan/ecs: 
		cd aws-ecs && terraform init && terraform plan -var="env=Dev"

PHONY: apply/ecs
apply/ecs: # Applying ECS Deployment
apply/ecs: 
		cd aws-ecs && terraform init && terraform apply --auto-approve -var="env=Dev"

PHONY: destroy/ecs
destroy/ecs: # Destroying ECS Deployment
destroy/ecs: 
		cd aws-ecs && terraform init && terraform destroy --auto-approve -var="env=Dev"



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

