module "devcontainer_repository" {
  source          = "./modules/standard-github-repo"
  name            = ".devcontainer"
  review_user_ids = [data.github_user.owner.id]
}
