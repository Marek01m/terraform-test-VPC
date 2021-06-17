provider "aws" {
  region = "eu-central-1"
}


##########
# VPC
##########

####################################################################
resource "aws_vpc" "Main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}
####################################################################
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
}
######    PRIVATE    ###############################################
resource "aws_subnet" "privatesubnet1" {
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false
}
resource "aws_subnet" "privatesubnet2" {
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false
}
####################################################################
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}
####################################################################
resource "aws_route_table_association" "PrivateRTassociation1" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.PrivateRT.id
}
resource "aws_route_table_association" "PrivateRTassociation2" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.PrivateRT.id
}

######    PUBLIC    ###############################################
resource "aws_subnet" "publicsubnet3" {
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}
####################################################################
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}
####################################################################
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.publicsubnet3.id
  route_table_id = aws_route_table.PublicRT.id
}
