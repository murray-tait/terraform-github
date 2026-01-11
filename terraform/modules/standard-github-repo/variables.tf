variable "name" {
  type = string
}

variable "review_user_ids" {
  type = list(string)
}

variable "visibility" {
  type    = string
  default = "public"
}
