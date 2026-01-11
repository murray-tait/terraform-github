module "parent_repository" {
  source          = "./modules/standard-github-repo"
  name            = "parent"
  review_user_ids = [data.github_user.owner.id]
}
