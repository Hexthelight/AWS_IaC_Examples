terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs            = var.vpc_azs
  public_subnets = var.vpc_public_subnets

  tags = var.tags
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name   = "Example SG"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port  = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = var.tags

}

resource "aws_lb" "web_elb" {
  name               = "web-elb"
  load_balancer_type = "application"
  security_groups    = [module.security-group.security_group_id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  tags = var.tags
}

resource "aws_lb_target_group" "web_elb" {
  name     = "webserver-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  tags = var.tags
}

resource "aws_lb_listener" "web_elb" {
  load_balancer_arn = aws_lb.web_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_elb.arn
  }

  tags = var.tags
}

resource "aws_launch_configuration" "test_asg" {
  name          = "this is a test launch config"
  image_id      = "ami-0cf754bf60ea3bf22"
  instance_type = "t2.micro"
  security_groups = [module.security-group.security_group_id]
}

resource "aws_autoscaling_group" "test_asg" {
  name                      = "this is a test ASG"
  min_size                  = 0
  max_size                  = 3
  desired_capacity          = 1
  health_check_type = "ELB"
  launch_configuration = aws_launch_configuration.test_asg.id
  vpc_zone_identifier       = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  target_group_arns = [aws_lb_target_group.web_elb.arn]

  tags = [var.tags]
}