/*
# Iam user roles
variable "admin_user_arns" {
  description = "List of IAM user ARNs to grant admin access to the EKS cluster"
  type        = list(string)
  default     = []
}


resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.admin_user_arns
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_AmazonEKSClusterAdminPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"
  role       = aws_iam_role.eks_admin_role.name
}
*/