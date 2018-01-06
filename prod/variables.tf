variable "masterkey" {
  description = "name of the master key for region"
  default     = "masterkey-tivix-ireland"
}

variable "instance_type" {
  description = "instance type like t2.micro, t2.medium etc"
  default     = "t2.micro"
}

variable "project_name" {
  description = "Project name"
  default     = "terraform-base"
}

variable "owner" {
  description = "Put here your name - it will serve as environment owner"
  default     = "Michal"
}

variable "env" {
  default = "prod"
}

variable "aws_region" {
  default = "eu-west-1"
}
