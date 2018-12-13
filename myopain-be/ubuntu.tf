provider "aws" {
  region     = "us-east-1"
}

data "aws_ami" "Base-Ubuntu-16" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name = "tag:Name"
    values = ["Base-Ubuntu-16"]
  }

  most_recent = true
}

resource "aws_instance" "Base-Ubuntu-16" {
  ami           = "${data.aws_ami.Base-Ubuntu-16.id}"
  instance_type = "t2.small"
  security_groups = ["PL-default"]
  iam_instance_profile = "PL-CodeDeployEC2"
  tags {
    Name = "PL-Myopain-BE"
  }
  key_name = "pl-deploy" ### Replace it with an existing key
	provisioner "remote-exec" {
 connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("/var/lib/jenkins/workspace/NewInstance-Terraform-BE/pl-deploy.pem")}" ### provide the key
    timeout = "4m"
    agent = false
}
 }
}
