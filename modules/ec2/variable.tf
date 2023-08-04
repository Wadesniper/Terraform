variable "maintainer" {
  type    = string
  default = "SBWADE"
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

variable "ssh_key" {
  type    = string
  default = "DevOps"
}

variable "sg_name" {
  type    = string
  default = "NULL"
}

variable "public_ip" {
  type    = string
  default = "NULL"
}

variable "AZ" {
  type    = string
  default = "us-east-1b"
}

variable "user" {
  type    = string
  default = "ubuntu"
}