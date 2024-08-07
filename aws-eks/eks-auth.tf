# eks authentication 
/*
resource "aws_eks_access_entry" "eks_access_entry" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = ""
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_access_entry_ass" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = ""

  access_scope {
    type       = "cluster"
  }
}
*/
/*
resource "aws_iam_user_policy_attachment" "user_eks_admin" {
  user       = ""  // Replace with your actual user name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"
}


data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}


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
      {
        userarn  = ""
        username = ""
        groups   = ["system:masters"]
      }
    ])  }
}
*/