variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "example-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "vpc_public_subnets" {
  description = "Public Subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.5.0/24"]
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
