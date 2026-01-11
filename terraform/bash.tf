
module "bash_repository" {
  source          = "./modules/standard-github-repo"
  name            = "bash"
  review_user_ids = [data.github_user.owner.id]
}
