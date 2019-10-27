resource "aws_instance" "example" {
  ami  = var.AMIS[var.AWS_REGION]
  instance_type = "t3.micro"
}

resource "aws_instance" "example1" {
  ami  = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
}


resource "aws_s3_bucket" "b" {
  bucket = "yaniv-bucket"
  acl    = "private"
}