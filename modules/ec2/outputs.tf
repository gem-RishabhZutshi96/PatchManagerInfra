output "ssm_ec2_ami" {
    value = aws_instance.ssm_patch_manager_instance.id
}