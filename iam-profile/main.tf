# Create IAM  Profile with a role to be attached to my instance

resource "aws_iam_instance_profile" "myprofile" {
  name = "${var.project_name}-profile"
  role = var.role
}

