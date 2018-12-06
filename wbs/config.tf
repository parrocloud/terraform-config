provider "aws" {
  region     = "us-east-1"
}

data "aws_ami" "Base-CentOS" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name = "tag:Name"
    values = ["Base-CentOS"]
  }

  most_recent = true
}

resource "aws_instance" "Base-CentOS" {
  ami           = "${data.aws_ami.Base-CentOS.id}"
  instance_type = "t2.small"
  security_groups = ["PL-wbs"]
  iam_instance_profile = "PL-CodeDeployEC2"
  tags {
    Name = "PL-WBS"
  }
  key_name = "pl-deploy" ### Replace it with an existing key
	provisioner "remote-exec" {
 connection {
    type = "ssh"
    user = "centos"
    private_key = "${file("/var/lib/jenkins/workspace/NewInstance-Terraform/pl-deploy.pem")}" ### provide the key
    timeout = "4m"
    agent = false
}
 }
}
