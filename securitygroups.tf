#
#  EC2 Instances 
#
resource "aws_security_group" "ec2-security-group" {
    name        = "${random_pet.petname.id}-EC2-SG"
    description = "Allow inbound access to the EC2"
    vpc_id      = aws_vpc.vpc.id
    tags        = { Name = "${random_pet.petname.id}-EC2-SG" }

    depends_on = [ aws_vpc.vpc ]

}

resource "aws_security_group_rule" "ec2_ingress_http_rules" {
    type              = "ingress"
    description       = " Allow Inbound access via http"
    from_port         = var.ports_numbers[0]
    to_port           = var.ports_numbers[0]
    protocol          = "tcp"
    source_security_group_id = aws_security_group.alb-security-group.id
    security_group_id = aws_security_group.ec2-security-group.id
}

resource "aws_security_group_rule" "ec2_ingress_fromBastion_rules" {
    type              = "ingress"
    description       = " Allow Inbound access from bastion"
    from_port         = var.ports_numbers[4]
    to_port           = var.ports_numbers[4]
    protocol          = "-1"
    source_security_group_id = aws_security_group.bastion-security-group.id
    security_group_id = aws_security_group.ec2-security-group.id
}

resource "aws_security_group_rule" "ec2_ingress_ssh_rules" {
    type              = "ingress"
    description       = " Allow Inbound access via http"
    from_port         = var.ports_numbers[2]
    to_port           = var.ports_numbers[2]
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.ec2-security-group.id
}

resource "aws_security_group_rule" "ec2_egress_outbound" {
 type              = "egress"
 description       = "allow all"
 from_port         = 0
 to_port           = 0
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.ec2-security-group.id
}

#
#  EC2 Bastion 
#
resource "aws_security_group" "bastion-security-group" {
    name        = "${random_pet.petname.id}-Bastion-SG"
    description = "Allow inbound access to the Bastion"
    vpc_id      = aws_vpc.vpc.id
    tags        = { Name = "${random_pet.petname.id}-Bastion-SG" }

    depends_on = [ aws_vpc.vpc ]

}

resource "aws_security_group_rule" "bastion_ingress_fromEC2_rules" {
    type              = "ingress"
    description       = " Allow Inbound traffic from Ec2 security group"
    from_port         = var.ports_numbers[4]
    to_port           = var.ports_numbers[4]
    protocol          = "-1"
    source_security_group_id = aws_security_group.ec2-security-group.id
    security_group_id = aws_security_group.bastion-security-group.id
}

resource "aws_security_group_rule" "bastion_ingress_ssh_rules" {
    type              = "ingress"
    description       = " Allow Inbound access via the world"
    from_port         = var.ports_numbers[2]
    to_port           = var.ports_numbers[2]
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion-security-group.id
}

resource "aws_security_group_rule" "bastion_egress_outbound" {
 type              = "egress"
 description       = "allow all"
 from_port         = var.ports_numbers[4]
 to_port           = var.ports_numbers[4]
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.bastion-security-group.id
}


#
# Application Load Balancer 
#
resource "aws_security_group" "alb-security-group" {
    name        = "${random_pet.petname.id}-ALB-SG"
    description = "Allow inbound access to the ALB"
    vpc_id      = aws_vpc.vpc.id
    tags        = { Name = "${random_pet.petname.id}-ALB-SG" }

    depends_on = [ aws_vpc.vpc ]

}

resource "aws_security_group_rule" "alb_ingress_http_rules" {
    type              = "ingress"
    description       = " Allow Inbound access via http"
    from_port         = var.ports_numbers[0]
    to_port           = var.ports_numbers[0]
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.alb-security-group.id
}

resource "aws_security_group_rule" "alb_egress_outbound" {
 type              = "egress"
 description       = "allow all"
 from_port         = 0
 to_port           = 0
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.alb-security-group.id
}
