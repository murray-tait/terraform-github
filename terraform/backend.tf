terraform {
  backend "s3" {
    bucket       = "org.murraytait.experiment.build.terraform"
    key          = "env/github-terraform/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
