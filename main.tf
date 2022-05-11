terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

provider aws {
    profile = "default"
    region  = "eu-west-2"
}

# =====Create VPC=====
resource "aws_vpc" "VPC" {
    cidr_block = "10.10.0.0/16"

    tags = {
        Name = "VPC"
    }
}

# =====Create IGW=====

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = "IGW"
    }
}

# =====Create Public Subnets=====
resource "aws_subnet" "subnets" {
    count             = length(var.subnet_ips)
    vpc_id            = aws_vpc.VPC.id
    availability_zone = element(var.subnet_azs, count.index)
    cidr_block        = element(var.subnet_ips, count.index)
    tags = {
        Name = element(var.subnet_names, count.index)
    }
}

# =====Create RT =====
resource "aws_route_table" "RT"{
    vpc_id         = aws_vpc.VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
        Name = "RT"
    }
}

# =====Public RT association=====
resource "aws_route_table_association" "PublicAssociation" {
    count          = length(var.subnet_ips)
    subnet_id      = element(aws_subnet.subnets.*.id, count.index)
    route_table_id = aws_route_table.RT.id
}

# =====Create instance SG=====

resource "aws_security_group" "InstanceSG" {
    name = "InstanceSG"
    vpc_id      = aws_vpc.VPC.id
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ping"
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# =====Create Webserver1=====
resource "aws_instance" "NginxServer" { 
  ami           = "ami-034ef92d9dd822b08"
  instance_type = "t2.micro"
  key_name      = "aws_test_key"
  subnet_id      = aws_subnet.subnets.*.id [0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.InstanceSG.id]
  user_data = <<-EOF
            #! /bin/bash
            sudo amazon-linux-extras install nginx1 -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo fin v1.00!
    EOF

  tags                        = {
    Name                      = "NginxServer"
  }
}

