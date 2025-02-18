# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.env}-${random_pet.petname.id}-ecs-cluster"
}



# ECS Service
resource "aws_ecs_service" "main" {
  name            = "${var.env}-${random_pet.petname.id}-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "apache"
    container_port   = 80
  }
}

# Network Load Balancer
resource "aws_lb" "main" {
  name               = "${var.env}-${random_pet.petname.id}-ecs-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  subnet_mapping {
    subnet_id     = aws_subnet.public[0].id
    allocation_id = aws_eip.nlb[0].id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public[1].id
    allocation_id = aws_eip.nlb[1].id
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.env}-${random_pet.petname.id}-ecs-target-group"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}


resource "aws_lb_listener" "nlb_eip" {
  count             = 2
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  depends_on = [aws_eip.nlb]
}

output "load_balancer_dns" {
  value = aws_lb.main.dns_name
}