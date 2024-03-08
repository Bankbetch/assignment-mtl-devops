terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #   bucket  = "demo-eks-terraform-state"
  #   key     = "terraform.tfstate"
  #   region  = "ap-southeast-1"
  #   profile = "demo"
  # }
}
