#
#  EKS Instances 
#
resource "aws_security_group" "eks-security-group" {
    name        = "${random_pet.petname.id}-EKS-SG"
    description = "Allow inbound access to the EC2"
    vpc_id      = aws_vpc.vpc.id
    tags        = { Name = "${random_pet.petname.id}-EKS-SG" }

    depends_on = [ aws_vpc.vpc ]

}

resource "aws_security_group_rule" "eks_ingress_http_rules" {
    type              = "ingress"
    description       = " Allow Inbound access via http"
    from_port         = var.ports_numbers[4]
    to_port           = var.ports_numbers[4]
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.eks-security-group.id
}


resource "aws_security_group_rule" "eks_egress_outbound" {
 type              = "egress"
 description       = "allow all"
 from_port         = 0
 to_port           = 0
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.eks-security-group.id
}
