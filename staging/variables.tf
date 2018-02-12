variable "masterkey" {
  description = "name of the master key for region"
  default     = "masterkey-tivix"
}

variable "profile" {
  description = "name of profile from $HOME/.aws/credentials"
  default     = "tivix"
}

variable "instance_type" {
  description = "instance type like t2.micro, t2.medium etc"
  default     = "t2.medium"
}

variable "instances_count" {
  description = "how many ec2 instances to create"
  default     = 1
}

variable "project_name" {
  description = "Project name"
  default     = "terraform-base"
}

variable "owner" {
  description = "Put here your name - it will serve as environment owner"
  default     = "Michal"
}

variable "project_root_domain" {
  description = "Root domain name for the project"
  default     = ""
}

variable "project_domain" {
  description = "Actual domain or subomain name for the project"
  default     = ""
}

variable "env" {
  default = "staging"
}

variable "use_elb" {
  description = "Should elb be put in front of ec2?"
  default     = "false"
}

variable "use_r53" {
  description = "Should route53 set record for domain?"
  default     = "false"
}

variable "use_rds" {
  description = "Create rds?"
  default     = "false"
}

variable "skip_final_snapshot" {
  description = "Create final rds snapshot before destroy?"
  default     = "true"
}

variable "aws_region" {
  default = "eu-west-1"
}
