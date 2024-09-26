provider "aws" {
  region = "us-east-1"
}

# ECS Task Definition for Medusa
resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "medusa-container"
      image     = "202533508516.dkr.ecr.us-east-1.amazonaws.com/my-medusa-store:latest"  # Your ECR image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
    }
  ])

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}

# ECS Service using Fargate Spot and Existing ECS Cluster
resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = "arn:aws:ecs:us-east-1:202533508516:cluster/YASHCLUSTER"  # Use your existing ECS cluster ARN
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets         = ["subnet-07bb5e93c1524b561"]  # Use your existing subnet ID
    security_groups = [aws_security_group.allow_all.id]
    assign_public_ip = true
  }
}

# Security Group for your VPC and subnet
resource "aws_security_group" "allow_all" {
  vpc_id = "vpc-0fa504211dcbcc1ca"  # Your existing VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  lifecycle {
    create_before_destroy = false
    ignore_changes        = all
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Attach the ECS Task Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRolePolicy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
