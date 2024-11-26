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


# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name               = "dododocs-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "ssm-policy-attachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "dododocs-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }


  tags = {
    Name = "dododocs-alb-sg"
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Security group for Nginx EC2 instance"
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

resource "aws_security_group_rule" "nginx_ingress_from_alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Allow HTTP traffic from ALB to Nginx"
}

resource "aws_security_group_rule" "nginx_ingress_from_alb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Allow HTTPS traffic from ALB to Nginx"
}

# EKS Shared Node Security Group 데이터 소스
data "aws_security_group" "eks_shared_node_sg" {
  filter {
    name   = "group-name"
    values = ["eksctl-dododocs-cluster-cluster-ClusterSharedNodeSecurityGroup-B2TpwuTUXqlH"]
  }
}

resource "aws_security_group_rule" "nginx_ingress_from_eks_prometheus" {
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_sg.id
  source_security_group_id = data.aws_security_group.eks_shared_node_sg.id
  description              = "Allow Prometheus traffic from EKS nodes to Nginx"
}

resource "aws_security_group_rule" "nginx_ingress_from_eks_grafana" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_sg.id
  source_security_group_id = data.aws_security_group.eks_shared_node_sg.id
  description              = "Allow Grafana traffic from EKS nodes to Nginx"
}

resource "aws_instance" "nginx_instance" {
  ami                    = "ami-0de20b1c8590e09c5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_a.id
  key_name               = "dododocs-key"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = false
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name

  depends_on = [aws_security_group.nginx_sg]

  tags = {
    Name = "dododocs-nginx-instance"
  }
}