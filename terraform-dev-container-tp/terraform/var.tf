## ENVIRONMENT
variable "env" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "aws_profile" {
    type = string
}

## enabling Hostnames 
variable "enable_hostnames" {
    type = bool
    default = true
  
}


variable "cidr_ip" {
    type = string
    default = "10.0.0.0/16"
  
}

# public subent information
variable "map_ip_enable" {
    type = bool
    default = true
  
}
