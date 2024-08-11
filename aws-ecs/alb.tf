
# Create an ALB
resource "aws_lb" "main" {
  name               = "${var.vpc_names[0]}-${random_pet.petname.id}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = [aws_subnet.pub-Subnets["pub_subnet1"].id , aws_subnet.pub-Subnets["pub_subnet2"].id]

  enable_deletion_protection = false

  depends_on = [ aws_vpc.vpc ]
}

# Create a target group
resource "aws_lb_target_group" "main" {
  name     = "${var.vpc_names[0]}-${random_pet.petname.id}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Register the EC2 instance with the target group
/*
resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web.id
  port             = 80
}
*/
# Create a listener for the ALB
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
