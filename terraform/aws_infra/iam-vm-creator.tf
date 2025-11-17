###########################
# IAM overly permissive policy
###########################
resource "aws_iam_role" "vm_creator" {
  name = "vm_creator_overly_permissive"

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
  name = "AllowEverythingPolicy"
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
  name = "vm_overly_perm_profile"
  role = aws_iam_role.vm_creator.name

  tags = {
    owner = "christopher.ley@gmail.com"
  }
}