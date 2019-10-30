variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "terraform"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "terraform.pub"
}


resource "random_uuid" "ssh-key" { }

