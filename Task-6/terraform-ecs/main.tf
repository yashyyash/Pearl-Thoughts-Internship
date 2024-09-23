provider "aws" {
  region = "<region>"
}

# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.5.0"
  name    = "medusa-vpc"
  cidr    = "10.0.0.0/16"
  azs     = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

# ECS Cluster
resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  container_definitions    = jsonencode([{
    name        = "medusa-container"
    image       = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-medusa-store:latest"
    memory      = 512
    cpu         = 256
    essential   = true
    portMappings = [{
      containerPort = 9000
      hostPort      = 9000
      protocol      = "tcp"
    }]
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = "256"
  memory                   = "512"
}

# ECS Service
resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.public_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "medusa-container"
    container_port   = 9000
  }

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50
}

# Security Groups
resource "aws_security_group" "ecs_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 9000
    to_port     = 9000
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

# Load Balancer
resource "aws_lb" "medusa_lb" {
  name               = "medusa-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "medusa-target-group"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}
