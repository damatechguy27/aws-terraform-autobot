##########################
# Networking outputs  
##########################
output "vpc-id" {
    value = aws_vpc.vpc.id
}

output "pub_subnet_ids" {
    value = [for key, pubsubnet in aws_subnet.pub-Subnets : pubsubnet.id]
}

output "pub_subnet_azs" {
    value = [for key, pubsubnet in aws_subnet.pub-Subnets : pubsubnet.availability_zone]
}

output "priv_subnet_ids" {
    value = [for key, privsubnet in aws_subnet.priv-Subnets : privsubnet.id]
}

output "priv_subnet_azs" {
    value = [for key, privsubnet in aws_subnet.priv-Subnets : privsubnet.availability_zone]
}


########################
# Security Groups 
########################
output "ec2-sg" {
    value = aws_security_group.ec2-security-group.id
}

output "alb-sg" {
    value = aws_security_group.alb-security-group.id
}

output "ec2-bastion-sg" {
    value = aws_security_group.bastion-security-group.id
}

#
# LOAD BALANCER
#
output "alb_dns_name" {
  value = aws_lb.main.dns_name
}