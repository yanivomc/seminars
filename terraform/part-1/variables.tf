
variable "ec2typeVar" { 
 type = "string"
 default = "t3.large" 
}


variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a","us-west-1b","us-west-1c"]
}