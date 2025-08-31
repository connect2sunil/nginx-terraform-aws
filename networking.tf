locals {
  common_tags = {

    ManagedBy  = "Terraform"                              # This tag tells you (or your team) that this VPC was created and managed by Terraform.
    Project    = "Project1-Deploying-NGINX-Server-in-AWS" #Useful for grouping resources by project, environment, or billing context
    CostCentre = "ABC123"
  }
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    Name = "Nginx-Project-VPC"
  })
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tags, {
    Name = "Nginx-Project-PubSubnet"
  })

}

resource "aws_internet_gateway" "internet_GW" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "Nginx-Project-IGW"
  })

}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_GW.id
  }
  tags = merge(local.common_tags, {
    Name = "Nginx-Project-RT"
  })
}

resource "aws_route_table_association" "RT_Sub_association" {
  route_table_id = aws_route_table.public_RT.id
  subnet_id      = aws_subnet.public.id


}