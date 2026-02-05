module "aws_build_repository" {
  source     = "./modules/standard-github-repo"
  name       = "aws-build"
  visibility = "private"
}


