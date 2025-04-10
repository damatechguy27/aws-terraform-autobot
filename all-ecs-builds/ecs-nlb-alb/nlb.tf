
# Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "${var.env}-${random_pet.petname.id}-ecs-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb.id]
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
#  subnets            = [aws_subnet.public[*].id]

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

resource "aws_lb_target_group" "nlb-tg-http" {
  name        = "${var.env}-${random_pet.petname.id}-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  #target_type = "ip"
  target_type = "alb"

    # health_check {
    #     protocol           = "HTTP"
    #     path               = "/"
    #     port               = "traffic-port"
    #     interval           = 30
    #     timeout            = 5
    #     healthy_threshold   = 2
    #     unhealthy_threshold = 2
    # }

}

resource "aws_lb_listener" "nlb_listener-http" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg-http.arn
  }
}


resource "aws_lb_listener" "nlb_eip" {
  count             = 2
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg-http.arn
  }

  depends_on = [aws_eip.nlb]
}