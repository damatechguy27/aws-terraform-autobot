
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
PHONY: plan/eks-test
plan/eks-test: # Planning EKS Deployment
plan/eks-test: 
		cd aws-eks && terraform init && terraform plan

PHONY: apply/eks-test
apply/eks-test: # Applying EKS Deployment
apply/eks-test: 
		cd aws-eks && terraform init && terraform apply --auto-approve

PHONY: destroy/eks-test
destroy/eks-test: # Destroying EKS Deployment
destroy/eks-test: 
		cd aws-eks && terraform init && terraform destroy --auto-approve
