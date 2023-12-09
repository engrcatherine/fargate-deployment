## -------------------------------------------------
## Creating AWS VPC section for 2 teir Application
##------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.tag
  }
}

# --------------------------------------
## Creating AWS internet gateway section
## -------------------------------------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tag}-gw"
  }
}
## ----------------------------------------------
## Creating AWS private and public Subnet section
## ---------------------------------------------
resource "aws_subnet" "public_subnet_user" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_user_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_user_tag
  }
}
resource "aws_subnet" "private_subnet_application" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_application_cidr

  tags = {
    Name = var.private_subnet_application_tag
  }
}
## -------------------------------------------------------------
## Creating AWS Routing Table and Aassociation for Public Subnets
## -------------------------------------------------------------

resource "aws_route_table" "rpub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.tag}-rpub"
  }
}



resource "aws_route_table_association" "ra" {
  subnet_id      = aws_subnet.public_subnet_user.id
  route_table_id = aws_route_table.rpub.id
}


## ----------------------------------------
## Creating AWS Nat Gateway and ELP section
## ---------------------------------------
resource "aws_eip" "natip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.natip.id
  subnet_id     = aws_subnet.public_subnet_user.id
  depends_on    = [aws_internet_gateway.gw]

  tags = {
    Name = "gw NAT"
  }
}


## ----------------------------------------------------------------
## Creating AWS Routing Table and Aassociation for Private Subnets
## ----------------------------------------------------------------

resource "aws_route_table" "rpriv" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.tag}-rpub"
  }
}


resource "aws_route_table_association" "rapriv" {
  subnet_id      = aws_subnet.private_subnet_application.id
  route_table_id = aws_route_table.rpriv.id
}


## ----------------------------------------------------------------
## Creating AWS NACL and Securtity Group for ALB
## ----------------------------------------------------------------

resource "aws_network_acl" "nacl_private_app" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    rule_no    = 160
    action     = "allow"
    cidr_block = var.public_subnet_user_cidr
    protocol   = "tcp"
    from_port  = 8080
    to_port    = 8080
  }

  ingress {
    rule_no    = 170
    action     = "allow"
    cidr_block = var.public
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 200
    action     = "allow"
    cidr_block = var.public_subnet_user_cidr
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.tag}-nacl-private-subnet-app"
  }
}

##------------------------------------##
## Aws SG for APP-ec2####
##-------------------------------------##
resource "aws_security_group" "private_subnetapp_sgroup" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow inbound traffic from Public Load Balancers to Application"
    cidr_blocks = [var.public_subnet_user_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public]
  }

  tags = {
    Name = "${var.tag}-App-security-group"
  }
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-sg"
  }

  egress = [
    {
      cidr_blocks      = [var.public]
      description      = "public security group"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      ipv6_cidr_blocks = []
    }
  ]
}
#-------------------------------------#
#ECS SECURITY GROUP#
#-------------------------------------#
resource "aws_security_group" "ecs_task" {
  name   = "${var.ecs_sg_name}-sg-task-${var.ecs_environment}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = var.ecs_container_port
    to_port          = var.ecs_container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
