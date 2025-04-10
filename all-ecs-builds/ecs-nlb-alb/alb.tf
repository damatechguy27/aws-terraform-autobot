# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.env}-${random_pet.petname.id}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false
}

# Target Group for ECS Tasks
resource "aws_lb_target_group" "alb-tg-http" {
  name        = "${var.env}-${random_pet.petname.id}-alb-tg-http"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}

# ALB Listener
resource "aws_lb_listener" "alb-listener-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-http.arn
  }
}


resource "aws_lb_target_group_attachment" "alb_to_nlb_attachment" {
  target_group_arn   = aws_lb_target_group.nlb-tg-http.arn
  target_id          = aws_lb.alb.arn # Use ALB ARN as the target ID.
  port               = 80 
}