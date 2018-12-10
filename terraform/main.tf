provider "aws" {
  region = "us-east-1"
}

variable "instance_ips" {
  default = {
    "0" = "10.142.0.2"
    "1" = "10.142.0.3"
  }
}

variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default     = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "auth" {
  key_name   = "default"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "fabric" {
  count                  = 2
  private_ip             = "${lookup(var.instance_ips, count.index)}"
  ami                    = "ami-02e116fc9cc15c35c"
  instance_type          = "t2.large"
  key_name               = "default"
  subnet_id              = "${aws_subnet.fabric-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
}

resource "aws_vpc" "fabric-vpc" {
  cidr_block           = "10.142.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.fabric-vpc.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.fabric-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "fabric-subnet" {
  vpc_id                  = "${aws_vpc.fabric-vpc.id}"
  cidr_block              = "10.142.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = "${aws_vpc.fabric-vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.142.1.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8181
    to_port     = 8181
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
