variable "VPC_CIDR" {} 
variable "SUBNET_CIDR" {}
variable "SUBNET_AZ" {}

// Create VPC for Kuberntes master and Node
resource "aws_vpc" "devops_vpc" {
  cidr_block       = var.VPC_CIDR
  instance_tenancy = "default"

  tags = {
    Name = "DevOps-VPC"
  }
}


//Public _SUBNET

resource "aws_subnet" "devops_subnet" {
  depends_on = [
    aws_vpc.devops_vpc
  ]
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = var.SUBNET_CIDR
  availability_zone = var.SUBNET_AZ 
  map_public_ip_on_launch = true
  tags = {
    Name = "DevOps-Subnet"
  }
}

// Internet Gateway for Public Subnet

resource "aws_internet_gateway" "devops_ig" {
  depends_on = [
    aws_vpc.devops_vpc
  ]
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "DevOps-IG"
  }
}




// Route Table for  Internet Gateway of public_Sub to access internet

resource "aws_route_table" "devops_rt_ig" {
  depends_on = [
    aws_vpc.devops_vpc,
    aws_internet_gateway.devops_ig
  ]
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_ig.id
  }

  tags = {
    Name = "DevOps-RT-IG"
  }
}

// Assosiation Route Table with subnet

resource "aws_route_table_association" "devops_assosiate_rt_subnet" {
  depends_on = [
    aws_subnet.devops_subnet,
    aws_route_table.devops_rt_ig
  ]
  subnet_id     = aws_subnet.devops_subnet.id
  route_table_id = aws_route_table.devops_rt_ig.id
}


