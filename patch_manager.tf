module "ssm_server_ami" {
  source = "modules/ec2"
}

module "ssm_iam_role" {
  source = "modules/iam"
}

resource "aws_ssm_patch_baseline" "patch_baseline_ec2" {
  name            = "Patch-Baseline-ec2"
  operating_system = "WINDOWS"
  approved_patches = ["KB123456", "KB789012"]
}

resource "aws_ssm_patch_group" "ssm_patch_group" {
  baseline_id   = aws_ssm_patch_baseline.patch_baseline_ec2.id
  patch_group   = "ec2-patch-baseline-group"
}

resource "aws_ssm_maintenance_window" "ssm_maintenance_window" {
  name              = "ec2-ssm-maintenance-window"
  allow_unassociated_targets = true
  duration          = 3
  cutoff             = 1
  schedule          = "cron(0 4 ? * SUN *)"
}

resource "aws_ssm_maintenance_window_target" "ssm_maintenance_target" {
  window_id = aws_ssm_maintenance_window.ssm_maintenance_window.id
  name = "maintenance-window-target"
  resource_type = "INSTANCE"
  description  = "This is a maintenance window target"
  targets {
    key = "tag:Name"
    values = ["Production"]
  }
}

resource "aws_ssm_maintenance_window_task" "example" {
  window_id = aws_ssm_maintenance_window.ssm_maintenance_window.id
  task_arn = "AWS-RunPatchBaseline"
  task_type = "RUN_COMMAND"
  service_role_arn = module.ssm_iam_role.ssm_patch_manager_ec2_role.arn
  targets {
      key = "tag:Name"
      values = ["Production"]
    }
    task_invocation_parameters {
    run_command_parameters {
      service_role_arn     = module.ssm_iam_role.ssm_patch_manager_ec2_role.arn
      timeout_seconds      = 600
    }
}
}
