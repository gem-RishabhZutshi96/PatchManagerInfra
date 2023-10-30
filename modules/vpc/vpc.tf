resource "aws_vpc" "ec2_ssm_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ssm_public_subnet" {
  vpc_id            = aws_vpc.ec2_ssm_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "ssm_igw" {
  vpc_id = aws_vpc.ec2_ssm_vpc.id
}


resource "aws_route_table" "ssm_public_rt" {
  vpc_id = aws_vpc.ec2_ssm_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.ssm_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ssm_igw.id
}

resource "aws_route_table_association" "public_ssm_rt_assosiation" {
  subnet_id      = aws_subnet.ssm_public_subnet.id
  route_table_id = aws_route_table.ssm_public_rt.id
}