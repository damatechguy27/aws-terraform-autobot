output "alb-name" {
    value = aws_lb.alb.dns_name 
}


output "nlb-name" {
    value = aws_lb.nlb.dns_name 
}

output "eip1" {
    value = aws_eip.nlb[*].address
  
}


