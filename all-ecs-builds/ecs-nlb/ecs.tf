# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.env}-${random_pet.petname.id}-ecs-cluster"
}



# # ECS Service
# resource "aws_ecs_service" "main" {
#  # count = 2
#   name            = "${var.env}-${random_pet.petname.id}-ecs-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 2
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = aws_subnet.public[*].id
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.main.arn
#     container_name   = "apache"
#     container_port   = 80
#   }
# }


# output "load_balancer_dns" {
#   value = aws_lb.main.dns_name
# }