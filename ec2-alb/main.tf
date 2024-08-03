

# Create an EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0663b059c6536cac8" # Replace with your desired AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.pub-Subnets["pub_subnet1"].id
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
  user_data = base64encode(<<-EOF
                  #!/bin/bash
                  sudo yum -y update
                  sudo yum -y install httpd
                  sudo yum -y install git
                  sudo mkdir /home/games && sudo cd /home/games
                  sudo git clone https://github.com/damatechguy27/gameapps.git
                  sudo cp -rf gameapps/Glokar/* /var/www/html
                  sudo chown -R apache:apache /var/www/html/*
                  sudo systemctl start httpd
                  sudo systemctl enable httpd
                  sudo rm-rf /home/games
                  amazon-linux-extras install epel -y 
                  yum install -y stress
                  EOF
                  )
  tags = {
    Name = "${var.vpc_names[0]}-${random_pet.petname.id}-WebServer"
  }

  depends_on = [ aws_vpc.vpc ]
}

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
resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web.id
  port             = 80
}

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


