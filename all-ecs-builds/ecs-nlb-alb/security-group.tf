
# Security Groups
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.env}-${random_pet.petname.id}-ecs-tasks-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Application Load balancer SG
resource "aws_security_group" "alb" {
  name        = "${var.env}-${random_pet.petname.id}-alb-sg"
  description = "Allow inbound traffic from IP prefix list"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    #prefix_list_ids = [aws_ec2_managed_prefix_list.allowed_ips.id]
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.nlb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Network Load balancer SG
resource "aws_security_group" "nlb" {
  name        = "${var.env}-${random_pet.petname.id}-nlb-sg"
  description = "Allow inbound traffic from IP prefix list"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    #prefix_list_ids = [aws_ec2_managed_prefix_list.allowed_ips.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
