output "Public_DNS" {
    description = "URL of the Load Balancer"
    value = aws_lb.web_elb.dns_name
}
