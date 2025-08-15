terraform {
  backend "s3" {
    bucket       = "org.murraytait.experiment.build.terraform"
    key          = "env/github-terraform/terraform.tfstate"
    region       = "eu-west-1"
    profile      = "973963482762_TerraformStateAccess"
    use_lockfile = true
  }
}
