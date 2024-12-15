variable "location" {
  type = string
  default = "us-east-1"
}

variable "prod_account" {
  type = string
}

variable "uat_account" {
  type = string
}

variable "create_by" {
  type = string
  default = "DevOps"
}