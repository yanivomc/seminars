resource "aws_key_pair" "mykey" {
  key_name   = "${random_uuid.ssh-key.result}"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

