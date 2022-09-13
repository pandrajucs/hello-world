
resource "aws_instance" "k8s_server" {
  ami                         = "ami-08d4ac5b634553e16"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  iam_instance_profile        = "admin_role"
  key_name                    = "AWS"
  subnet_id                   = "subnet-0882f799e47d9f14e"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-076e6a71a275bf359"]
  user_data                   = file("script.sh")
  tags = {
    "Name" = "K8S-Server"
  }

}
