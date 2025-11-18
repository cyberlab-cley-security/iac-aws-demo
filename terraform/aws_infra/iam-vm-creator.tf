###########################
# IAM overly permissive policy
###########################
resource "aws_iam_role" "vm_creator" {
  name          = local.iam_vm_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    owner = "christopher.ley@gmail.com"
  }
}

resource "aws_iam_role_policy" "overly_permissive" {
  name = local.iam_vm_policy_name
  role = aws_iam_role.vm_creator.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "*"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "vm_profile" {
  name = local.iam_vm_profile_name
  role = aws_iam_role.vm_creator.name

  tags = {
    owner = "christopher.ley@gmail.com"
  }
}