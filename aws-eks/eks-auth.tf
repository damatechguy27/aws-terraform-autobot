# eks authentication 
/*
data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}
*/
/*
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}
*/
/*
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [aws_eks_node_group.eks_node_group]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn = aws_iam_role.eks_node_group_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])

    mapUsers = yamlencode([
      for user_arn in var.admin_user_arns : {
        userarn = user_arn
        username = "admin"
        groups = ["system:masters"]
      }
    ])
  }
}
*/