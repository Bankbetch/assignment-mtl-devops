variable "profile" {
  type = string
}

variable "aws_region" {
  type        = string
}


variable "cluster_name" {
  type        = string
}

variable "instance_types" {
  type        = map(object({
    type = list(string)
    min_size = number
    max_size = number
    desired_capacity = number
  }))
}

variable "eks_version" {
  type        = string
  default     = "1.29"
}

# nw
variable "vpc_cidr" {
  type        = string
}

variable "availability_zones" {
  type        = list(string)
}

variable "public_subnets" {
  type        = map(string)
}

variable "private_subnets" {
  type        = map(string)
}

variable "isStaging" {
  type    = string
  default = "true"
}