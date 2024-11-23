provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dododocs-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dododocs-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.0/20"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dododocs-public-a"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/dododocs-cluster" = "shared"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.16.0/20"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "dododocs-public-c"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/dododocs-cluster" = "shared"
  }
}

# Private Subnet
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.128.0/20"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "dododocs-private-a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/dododocs-cluster" = "shared"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.144.0/20"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "dododocs-private-c"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/dododocs-cluster" = "shared"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dododocs-public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

# NAT
resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "dododocs-nat-a"
  }
}

# resource "aws_eip" "nat_c" {
#   domain = "vpc"

#   tags = {
#     Name = "dododocs-nat-c"
#   }
# }

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "dododocs-nat-a"
  }
}

# resource "aws_nat_gateway" "nat_c" {
#   allocation_id = aws_eip.nat_c.id
#   subnet_id     = aws_subnet.public_c.id

#   tags = {
#     Name = "dododocs-nat-c"
#   }
# }

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "dododocs-private-a-rt"
  }
}

# resource "aws_route_table" "private_c" {
# 	vpc_id = aws_vpc.main.id
	
# 	route {
# 		cidr_block	= "0.0.0.0/0"
# 		nat_gateway_id = aws_nat_gateway.nat_c.id
# 	}

# 	tags ={
# 		Name = "dododocs-private-c-rt"
# 	}
# }

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_a.id
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTPS traffic to ALB"
  vpc_id      = aws_vpc.main.id

  # HTTPS 접근 허용
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dododocs-alb-sg"
  }
}


# Nginx EC2 Instance
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP and SSH traffic for Nginx"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dododocs-nginx-sg"
  }
}

# ALB에서 Nginx로 트래픽 허용
resource "aws_security_group_rule" "nginx_ingress_from_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.nginx_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_instance" "nginx_instance" {
  ami                    = "ami-0de20b1c8590e09c5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_a.id
  key_name               = "dododocs-key"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = false

  depends_on = [aws_security_group.nginx_sg]
  sla
  tags = {
    Name = "dododocs-nginx-instance"
  }
}