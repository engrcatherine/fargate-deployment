## ------------------------------
## Creating Variable section
##--------------------------------

variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "region" {
  default = "us-east-1"
}
variable "profile" {
  default = "staging"
}
variable "public" {
  default = "0.0.0.0/0"
}
variable "tag" {
  default = "private"
}
variable "private_subnet_application_cidr" {
    default =  "10.0.1.0/24"
  
}
variable "private_subnet_application_tag" {
  default = "private subnet application"
}

variable "public_subnet_user_cidr" {
    default =  "10.0.1.0/24"
  
}
variable "public_subnet_user_tag" {
  default = "public subnet user"
}







