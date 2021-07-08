# variables
variable aws_access_key {}
variable aws_secret_key {}

variable "region" {
  type = string
  default = "us-east-1"
}
variable "master_account_number" {
  type = string
  description = "Account number of the master account"
}


