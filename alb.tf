provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "demo2" {
    ami = "ami-00eeedc4036573771"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.demosg.name]
    key_name = "myohiokey"
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
    name = "demosg"
    description = "demosg"

    ingress { 
        to_port = 80
        from_port  = 80
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

resource "aws_lb" "testlb" {
    name = "demoalb"
    load_balancer_type = "application"
    internal = false    
    security_groups = [aws_security_group.demosg.id]
    subnets = data.aws_subnets.default_subnet.ids
}




resource "aws_lb_listener" "demolb" {
    port  = 80
    protocol = "HTTP"
    load_balancer_arn = aws_lb.testlb.arn
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.demotg.arn
    }
}

resource "aws_lb_target_group" "demotg" {
    name = "target"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default_vpc.id
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 3
        interval = 30
        timeout = 10
        path = "/"
        port = 80
    }
}

resource "aws_lb_target_group_attachment" "test" {
    target_group_arn = aws_lb_target_group.demotg.arn
    target_id = aws_instance.demo2.id
    port = 80
}