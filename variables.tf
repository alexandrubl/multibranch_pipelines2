variable "subnet_ips" {
    description = " subnet_ips"
    type        = list
    default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "subnet_names" {
    description = " subnet_names"
    type        = list
    default     = ["subnetA", "subnetB"]
}

variable "subnet_azs" {
    description = " subnet_azs"
    type        = list
    default     = ["eu-west-2a", "eu-west-2b"]
}