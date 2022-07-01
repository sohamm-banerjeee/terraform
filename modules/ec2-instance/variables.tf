variable "cidr_block" {
        type = string
        default = "10.1.0.0/16"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "ami" {
        default = "ami-092b43193629811af"
}