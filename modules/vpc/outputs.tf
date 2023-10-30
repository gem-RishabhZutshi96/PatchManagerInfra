output "ssm_ec2_subnet" {
    value =  aws_subnet.ssm_public_subnet.id
}

output "ssm_vpc_id" {
    value = aws_vpc.ec2_ssm_vpc.id  
}
