resource "aws_eip" "nat" {
  tags = {
    Name = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.name}-${substr(var.az, -1, 3)}"
  }
}
