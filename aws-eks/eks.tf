// this script is to deploy a tesk eks cluster 
// to test upgrades and additional operations on the EKS cluster kubernetes 
// to upgrade the terraform file after upgrade perform a terraform plan -refresh-only 
// or terraform apply -refresh-only 
// This allows you to safely update your state file without making changes to your infrastructure


# IAM Role for EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.vpc_names[0]}-${random_pet.petname.id}-EKS-LAB-Cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = [aws_subnet.pub-Subnets["pub_subnet1"].id , aws_subnet.pub-Subnets["pub_subnet2"].id]
    security_group_ids = [aws_security_group.eks-security-group.id]
  }

  depends_on = [
      aws_iam_role_policy_attachment.eks_cluster_policy,
      aws_vpc.vpc,
      aws_security_group.eks-security-group
      ]
}

# Adding EKS add ons for cluster 
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}


# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.vpc_names[0]}-${random_pet.petname.id}-NodeGroup"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [aws_subnet.pub-Subnets["pub_subnet1"].id , aws_subnet.pub-Subnets["pub_subnet2"].id]
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
    aws_vpc.vpc,
    aws_security_group.eks-security-group
  ]
}

# Time sleep to allow EKS to fully provision
resource "time_sleep" "wait_for_kubernetes" {
  depends_on = [aws_eks_node_group.eks_node_group]
  create_duration = "60s"
}

# Kubernetes provider
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name]
    command     = "aws"
  }
}

/*
# Apache Deployment
resource "kubernetes_deployment" "apache" {
  depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "apache"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "apache"
      }
    }

    template {
      metadata {
        labels = {
          app = "apache"
        }
      }

      spec {
        container {
          image = "httpd:2.4"
          name  = "apache"

          port {
            container_port = 80
          }

          # Create a simple index.html file with "Hello World"
          lifecycle {
            post_start {
              exec {
                command = ["/bin/sh", "-c", "echo '<html><body><h1>Hello World</h1></body></html>' > /usr/local/apache2/htdocs/index.html"]
              }
            }
          }
        }
      }
    }
  }
}

# Apache Service (Load Balancer)
resource "kubernetes_service" "apache" {
  depends_on = [time_sleep.wait_for_kubernetes]

  metadata {
    name = "apache"
  }

  spec {
    selector = {
      app = "apache"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

# Output the Load Balancer URL
output "load_balancer_url" {
  value = kubernetes_service.apache.status.0.load_balancer.0.ingress.0.hostname
}
*/