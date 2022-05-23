data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_cidr_block
  instance_tenancy     = var.aws_vpc_instance_tenancy
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "${var.app_name}-vpc"
    environment  = var.app_env
    appname = var.app_name
    appid = var.app_id
  }
}

resource "aws_subnet" "main-public" {
  #count                   = local.subnet_count
  count                   = var.no_of_subnets
  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index + 1}"
    environment  = var.app_env
    appname = var.app_name
    appid = var.app_id
  }
}

resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-gw"
    environment  = var.app_env
    appname = var.app_name
    appid = var.app_id
  }
}

resource "aws_route_table" "main-rtable" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "${var.app_name}-rtable"
    environment  = var.app_env
    appname = var.app_name
    appid = var.app_id
  }
}

resource "aws_route_table_association" "main-rtable-a" {
  count          = var.no_of_subnets
  subnet_id      = aws_subnet.main-public[count.index].id
  route_table_id = aws_route_table.main-rtable.id
}


