resource "aws_launch_template" "ecs_launch_template" {
  name = "${var.vpc_names[0]}-${random_pet.petname.id}-Launch-Temp"
  image_id      = data.aws_ami.latest_amazon_linux.id  # Specify a suitable ECS-optimized AMI
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.apache_cluster.name} >> /etc/ecs/ecs.config
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.pub-Subnets["pub_subnet1"].id , aws_subnet.pub-Subnets["pub_subnet2"].id]  # Specify the subnets

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs_launch_template.id
        version            = "$Latest"
      }

      override {
        instance_type = "t3.micro"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.vpc_names[0]}-${random_pet.petname.id}-Apache"
    propagate_at_launch = true
  }
}
