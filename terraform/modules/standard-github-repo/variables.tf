variable "name" {
  type = string
}

variable "review_user_ids" {
  type = list(string)
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_role_to_assume" {
  type = string
}

variable "environments" {
  type    = string
  default = true
}
