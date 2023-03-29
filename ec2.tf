provider "aws" {
    region = "us-east-2"
}


resource "aws_instance" "demo2" {
    ami = var.ami
    instance_type = var.type
    security_groups = [aws_security_group.demosg.name]
    key_name = var.keypair
}


data "aws_vpc" "default_vpc" {
    default = true
}
data "aws_subnets" "default_subnet" {
     filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_security_group" "demosg" {
    name = "aws-sg"
    vpc_id = data.aws_vpc.default_vpc.id

    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}