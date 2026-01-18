module "aws_build_repository" {
  source          = "./modules/standard-github-repo"
  name            = "aws-build"
  review_user_ids = [data.github_user.owner.id]
  visibility      = "private"
}


