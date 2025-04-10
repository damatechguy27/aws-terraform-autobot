# docker push ${aws_ecr_repository.app_repo.repository_url}:apache-latest
# docker push ${aws_ecr_repository.app_repo.repository_url}:nginx-latest
# export that variable 
# export TF_VAR_env=dev
# how to pass the variable in as your running the terraform command terraform apply -var="env=dev"

# ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.env}-${random_pet.petname.id}-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "app_repo_policy" {
  repository = aws_ecr_repository.app_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images for each tag"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["apache", "nginx"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


output "repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}