## ------------------------------
## Creating Variable section
##--------------------------------
variable "region" {
  default = "us-east-1"
}
variable "tag" {
  default = "my-vpc"
}
variable "ecs_vpc_id" {
  type    = string
  default = "your-vpc-id" # Replace with the appropriate default value
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "private_subnet_application_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_user_cidr" {
  default = "10.0.2.0/24"
}

variable "public" {
  default = "0.0.0.0/0"
}

variable "private" {
  default = "10.0.0.0/8"
}

variable "private_subnet_application_tag" {
  default = "private-subnet-app"
}

variable "public_subnet_user_tag" {
  default = "public-subnet-user"
}
variable "ecs_container_port" {
  type    = number
  default = 8080 # Replace with the appropriate default value
}

variable "ecs_sg_name" {
  type    = string
  default = "ecs-sg-task"
}

variable "environment" {
  default = "production"
}
variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}
variable "container_port" {
  default = 8080
}
variable "container_environment" {
  default = "pro"
}
variable "container_image" {
  default = "latest"
}
variable "ecs_environment" {
  description = "Environment for the ECR repository"
  type        = string
  default     = "dev"
}

variable "ecs_main_name" {
  description = "Name for the ECR repository"
  type        = string
  default     = "my-ecr-repo" # Replace with your desired default value
}


variable "main" {
  description = "Main configuration variables"
  type = object({
    name = string
    // Other attributes related to 'main'
  })
  # You can set default values if needed:
  default = {
    name = "my-main-name"
    // Other default attributes related to 'main'
  }
}

variable "repo_name" {
  type    = string
  default = "webapp" # Replace with your desired default value
}
