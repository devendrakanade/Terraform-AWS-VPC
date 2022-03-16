variable "Env" {
  default = "dev" #
}
variable "Aws_Region" {
  default = "us-east-1" 
}

variable cidr_block_public{
    type= list
    default= ["10.0.1.0/24", "10.0.2.0/24"] 
}

variable cidr_block_private{
    type= list
    default= ["10.0.5.0/24", "10.0.4.0/24"] 
}

variable "avail_zone" {
  description = "availability zone"
  type = list
  default = ["ap-south-1a","ap-south-1b"] 
} 
