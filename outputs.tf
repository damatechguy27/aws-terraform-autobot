##########################
# Networking outputs  
##########################


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


