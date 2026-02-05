variable "plan_variables" {
  type    = map(string)
  default = {}
}

variable "deploy_variables" {
  type    = map(string)
  default = {}
}

variable "shared_variables" {
  type    = map(string)
  default = {}
}

variable "plan_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "shared_secrets" {
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

variable "review_user_ids" {
  type        = list(string)
  default     = []
  description = "List of user IDs who are reviewers"
}

variable "review_teams" {
  type        = list(string)
  default     = []
  description = "List of team IDs who are reviewers"
}
