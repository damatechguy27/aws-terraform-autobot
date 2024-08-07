#######################################
#
# PROVIDER VARIABLES 
#######################################
# variable "provide_region" {
#   type =  string
#   default = "us-west-2"
# }

# variable "credentials_path" {
#     type = string
#     default = "C:\\Users\\dmit27\\.aws\\credentials"
  
# }

# variable "aws_access_key" {
#   type = string
# }

# variable "aws_sec_key" {
#   type = string  
# }

# variable "aws_profile" {
#   type = string
# }



########################################
# NETWORKING VARIABLES
#########################################
##### VPC information 
variable "vpc_names" {
    type = list(string)
    default = ["mars", "saturn"]
  
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

variable "pub_subnets" {

    type = map(object({
      cidr_block = string
      availability_zone= string
    }))
    default = {
      "pub_subnet1" = {
        cidr_block="10.0.1.0/24"
        availability_zone="us-west-2a"        
      }
      "pub_subnet2" = {
        cidr_block="10.0.2.0/24"
        availability_zone="us-west-2b"        
      }
    }
  
}

variable "priv_subnets" {

    type = map(object({
      cidr_block = string
      availability_zone= string
    }))
    default = {
      "priv_subnet1" = {
        cidr_block="10.0.100.0/24"
        availability_zone="us-west-2a"        
      }
      "priv_subnet2" = {
        cidr_block="10.0.200.0/24"
        availability_zone="us-west-2b"        
      }
    }
  
}






######################
# Security Groups 
######################

variable "ports_numbers" {
  type = list(number)
  default = [ 80, 443, 22, 3389, 0 ]
  
}