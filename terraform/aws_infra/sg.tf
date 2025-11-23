#########
# Security group configuration

resource "aws_security_group" "ec2-bastion" {

  description   = "SG for ec2-bastion"
  name          = local.sg_name
  vpc_id        = module.vpc.vpc_id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "backdoor"
    from_port   = 6789
    to_port     = 6789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Ingress to MongoDB only from EKS worker nodes
  ingress {
    description       = "MongoDB access from EKS nodes"
    from_port         = 27017
    to_port           = 27017
    protocol          = "tcp"
    security_groups   = [module.eks.node_security_group_id] #to allow only connection from EKS node group to MongoDB
  }

  egress {
    description = "Allow outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.sg_name
    owner = "christopher.ley@gmail.com"
  }
}

## Add EC2 security Group to EKS cluster security Group
resource "aws_security_group_rule" "ec2_to_eks" {
  type                      = "ingress"
  from_port                 = 443
  to_port                   = 443
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.ec2-bastion.id
  security_group_id         = module.eks.cluster_security_group_id
  description               = "Add ec2-bastion security group to allow to connect to EKS cluster control plane" 
}