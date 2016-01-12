variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-west-2"
}
variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}
variable "amis" {
    default = {
        us-west-2 = "ami-c94856a8"
    }
}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "moz-provision" {
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.default.name}"]
    key_name = "${var.key_name}"

    # main script to setup packages and start daemons
    provisioner "file" {
        source = "configs/"
	destination = "/home/ubuntu/"
	connection {
	   user = "ubuntu"
	}
    }

    provisioner "remote-exec" {
        inline = [
	    "chmod +x /home/ubuntu/script.sh",
	    "/home/ubuntu/script.sh"
	]
	connection {
	   user = "ubuntu"
	}
    }
}

resource "aws_eip" "ip" {
    instance = "${aws_instance.moz-provision.id}"
}

output "public_ip" {
    value = "${aws_eip.ip.public_ip}"
}

output "private_ip" {
    value = "${aws_eip.ip.private_ip}"
}

resource "aws_security_group" "default" {
    name = "moz-provider-secgrp"
    description = "Used in the terraform"

    # SSH access from anywhere
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # outbound internet access
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
    