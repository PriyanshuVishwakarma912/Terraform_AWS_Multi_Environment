variable "ec2_instance_name" {
    description = "This variabl holds ec2 instance name"
    default = "terra-iac-server"
    type = string
}

variable "ec2_volume_size" {
    description = "This variabl holds ec2 instance volume size"
    default = "8"
    type = number
}

variable "ec2_instance_state" {
    description = "This variabl holds ec2 instance state"
    default = "running"
    type = string
}

variable "ec2_ami_id" {
    description = "This variable holds ami id of ec2"
    default = "ami-05d2d839d4f73aafb"
    type = string
  
}
variable "ec2_instance_type" {
    description = "This variable holds instance type"
    default = "t3.micro"
    type = string
  
}

variable "ec2_instance_count" {
    description = "This variable holds instance count"
    # default = 1
    type = number
  
}

variable "env"{
    description = "This holds the environment name"
    type = string
    # default = "dev"
}