variable "profile" {
  type = string
}

variable "aws_region" {
  type        = string
  default = "ap-southeast-1"
}

variable "key_name" {
  type        = string
}

variable "bucket_name" {
  type = string
}

variable "sqs_name" {
  type = string
}

variable "tags" {
  type        = map(string)
}

variable "pgp_key" {
  description = "base-64 encoded PGP public key"
  type        = string
  default     = ""
}