output "nlb-name" {
    value = aws_lb.main.dns_name 
}


output "eip1" {
    value = aws_eip.nlb[*].address
  
}