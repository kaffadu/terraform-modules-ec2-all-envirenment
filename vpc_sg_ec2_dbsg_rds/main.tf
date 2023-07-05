
# Create VPC
resource "aws_vpc" "TP2-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create Subnets : public
resource "aws_subnet" "web_public_subnets" {
  count                                       = length(var.web_public_subnets_cidr)
  vpc_id                                      = aws_vpc.TP2-vpc.id
  cidr_block                                  = var.web_public_subnets_cidr[count.index]
  availability_zone                           = var.availability_zone[count.index]
  map_public_ip_on_launch                     = var.map_public_ip_on_launch
  

  tags = {
    Name = "${var.identifier1}_public_subnet-${count.index+1}"
  }
}



# Create Subnets : Private
resource "aws_subnet" "app_private_subnets" {
  count             = length(var.app_private_subnets_cidr)
  vpc_id            = aws_vpc.TP2-vpc.id
  cidr_block        = var.app_private_subnets_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.identifier2}_private_subnet-${count.index+1}"
  }
}



# Create Internet Gateway
resource "aws_internet_gateway" "TP2-igw" {
  vpc_id = aws_vpc.TP2-vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create Elastic IP Adress
resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-Elastic IP"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "TP2-ngw" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.web_public_subnets[1].id
  
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

}


# Create Private Route table: attach NAT Gateway 
resource "aws_route_table" "TP2-private-rt" {
  vpc_id = aws_vpc.TP2-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TP2-igw.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Create Public Route table: attach Internet Gateway 
resource "aws_route_table" "TP2-public-rt" {
  vpc_id = aws_vpc.TP2-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TP2-igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


# Public Route table association with public subnets
resource "aws_route_table_association" "TP2-public-rt-association" {
  count          = length(var.web_public_subnets_cidr)
  subnet_id     = aws_subnet.web_public_subnets[count.index].id
  route_table_id = aws_route_table.TP2-public-rt.id
}



# Private Route table association with private subnets
resource "aws_route_table_association" "TP2-private-rt-association" {
  count          = length(var.app_private_subnets_cidr)
  subnet_id     = aws_subnet.app_private_subnets[count.index].id
  route_table_id = aws_route_table.TP2-private-rt.id
}

# Create Dynamic security group for both EC2 and RDS
resource "aws_security_group" "TP2-sg" {
    name        = var.name
    description = "enable http, ssh and MySQL access on port 80, 22 and 3306"
    vpc_id      = aws_vpc.TP2-vpc.id

    dynamic "ingress" {
      iterator = port
      for_each = var.ingressrules
      content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }

    dynamic "egress" {
      iterator = port
      for_each = var.egressrules
      content {
      from_port = port.value
      to_port = port.value
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  tags   = {
    Name = "${var.name}-sg"
  } 
}


# Data for the EC2 Instance
data "aws_ami" "ec2_instance" {

  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*"]
  }

}

# Define The Local Varying Values using the "locals" descriptor
locals {
  aws_instance = {
    "TP2private1" = { subnet_id = aws_subnet.app_private_subnets[0].id, tags = { Name = "${var.private-server1}" } }
    "TP2private2" = { subnet_id = aws_subnet.app_private_subnets[1].id, tags = { Name = "${var.private-server2}" } }
    "TP2public1"  = { subnet_id = aws_subnet.web_public_subnets[0].id, tags = { Name = "${var.public-server1}" } }
    "TP2public2"  = { subnet_id = aws_subnet.web_public_subnets[1].id, tags = { Name = "${var.public-server2}" } }
  }
}

# Create The EC2 Instance
resource "aws_instance" "TP2_instance" {
  for_each                    = local.aws_instance
  subnet_id                   = each.value.subnet_id
  tags                        = each.value.tags
  ami                         = data.aws_ami.ec2_instance.id
  instance_type               = var.instance_type
  key_name                    = "${var.project_name}-key"
  vpc_security_group_ids      = ["${aws_security_group.TP2-sg.id}"]
  iam_instance_profile        = "${var.project_name}-profile"
  associate_public_ip_address = var.associate_public_ip_address

}


# Create Data Base Subnet Group

resource "aws_db_subnet_group" "dbsg" {
  name       = "dbsg"
  subnet_ids = [aws_subnet.app_private_subnets[0].id, aws_subnet.app_private_subnets[1].id]

  tags = {
    Name = "${var.project_name}-dbsg"
  }
}

# Create RDS
resource "aws_db_instance" "MyRDSSQL" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = ["${aws_security_group.TP2-sg.id}"]
  db_subnet_group_name   = var.db_subnet_group_name

}