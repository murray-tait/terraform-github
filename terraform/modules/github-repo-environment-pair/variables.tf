variable "plan_variables" {
  type    = map(string)
  default = {}
}

variable "deploy_variables" {
  type    = map(string)
  default = {}
}

variable "plan_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "deploy_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "repository_name" {
  type = string
}

variable "environment" {
  type = string
}
