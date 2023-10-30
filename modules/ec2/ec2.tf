module "ssm_subnet" {
    source = "./modules/vpc"  
}

module "iam_ssm_role" {
    source = "./modules/iam"
} 


resource "aws_security_group" "ssm_instance_sec_grp" {
  name        = "SSM-Instance-Security-Group"
  description = "Allow HTTPS and HTTP inbound traffic"
  vpc_id      = module.ssm_subnet.ssm_vpc_id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

}  
}


resource "aws_instance" "ssm_patch_manager_instance" {
  ami           = var.ssm_ami_id_one
  instance_type = var.instance_type
  iam_instance_profile = module.iam_ssm_role.ssm_patch_manager_ec2_role  
  subnet_id     = module.ssm_subnet.ssm_ec2_subnet
  vpc_security_group_ids = [aws_security_group.ssm_instance_sec_grp.id]
  tags = {
    Name = "Production"
  }
}

resource "aws_instance" "ssm_patch_manager_instance_two" {
  ami           = var.ssm_ami_id_two
  instance_type = var.instance_type
  iam_instance_profile = module.iam_ssm_role.ssm_patch_manager_ec2_role  
  subnet_id     = module.ssm_subnet.ssm_ec2_subnet
  vpc_security_group_ids = [aws_security_group.ssm_instance_sec_grp.id]
    tags = {
    Name = "Production"
  }
}
