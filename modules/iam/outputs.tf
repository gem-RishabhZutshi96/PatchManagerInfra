output "ssm_patch_manager_ec2_role" {
    value = aws_iam_role.patch_manager_ssm_role.arn
}
