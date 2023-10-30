data "aws_iam_policy" "AmazonSSMManagedInstanceCore"{
    name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ssm_intsance_core_policy" {
    statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com", "forecast.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "patch_manager_ssm_role" {
    name = "patch_manager_ssm_role for server"
    assume_role_policy = data.aws_iam_policy_document.ssm_intsance_core_policy.json

    managed_policy_arns = [
        data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
    ]  
}