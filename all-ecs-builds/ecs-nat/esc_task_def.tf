# # ECS Task Definition
# resource "aws_ecs_task_definition" "app" {
#   family                   = "app-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"

#   container_definitions = jsonencode([
#     {
#       name  = "apache"
#       image = #"${aws_ecr_repository.apache.repository_url}:demonaire-latest"
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#     }
#     # {
#     #   name  = "nginx"
#     #   image = "nginx:latest"#"${aws_ecr_repository.nginx.repository_url}:nginx-latest"
#     #   portMappings = [
#     #     {
#     #       containerPort = 8080
#     #       hostPort      = 8080
#     #     }
#     #   ]
#     # }
#   ])
# }