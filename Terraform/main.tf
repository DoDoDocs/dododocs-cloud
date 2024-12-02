provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
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
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dododocs-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "dododocs-public-c"
  }
}

# Private Subnet
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.100.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "dododocs-private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.101.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "dododocs-private-c"
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
