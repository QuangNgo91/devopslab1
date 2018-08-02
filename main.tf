variable aws_access_key {
  default = "" 
}
variable aws_access_key {
  default = ""
}


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}" 
  region     = "ap-southeast-1"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-01b61262"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [
     "${aws_security_group.terraform-SG.id}"    
    ]
  subnet_id = "${aws_subnet.mainsn.id}"
  key_name = "z2-lab-key"
  tags {
        Name = "jenkins"
    } 
}

resource "aws_key_pair" "z2-lab"{
  key_name = "z2-lab-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA2uUa9jUhtlhrMwve+P+PWMk/GG0SQA3FARCHsk+bCP+1wffMZPwm8zN0/m+16FDjh77B+4to1CttBYrg1uwN/ET6RRVSPECP2tyIZegGbS2ij4hQWyRSHC/tPQVTBxSykerkFzRpDaTC/ks0t34xxn2xuinuqNZdtwh7O9npG8dGze5ijZOEUHqyPwENJGR2Cn4Si79S7IIJPWJuAtp7n6siArmhzT6UnCPstHxUR0cXbgAsldPKblh16OeNoqLXwz+GwZh0bBCFmHMQIm2nXRMQlT20AchgTRBMJPb1HutURLbUGwupAVH691o22CbHcI1FxSE9ZBIdE4gkOeC6sQ== rsa-key-20180731"
}

resource "aws_security_group" "terraform-SG" {
  name = "terraform-SG"
  vpc_id = "${aws_vpc.mainvpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "mainvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "mainvpc"
  }
}

resource "aws_subnet" "mainsn" {
  vpc_id     = "${aws_vpc.mainvpc.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "mainsn"
  }
}

resource "aws_subnet" "mainsnb" {
  vpc_id     = "${aws_vpc.mainvpc.id}"
  cidr_block = "10.0.2.0/24"
  
  tags {
    Name = "mainsnb"
  }
}

resource "aws_internet_gateway" "maingw" {
  vpc_id = "${aws_vpc.mainvpc.id}"

  tags {
    Name = "maingw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.mainvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.maingw.id}"
  }

  tags {
    Name = "mainrt"
  }
}