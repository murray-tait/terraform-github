data "github_user" "owner" {
  username = "murray-tait"
}

module "this_repository" {
  source             = "./modules/standard-github-repo"
  name               = "terraform-github"
  aws_role_to_assume = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids    = [data.github_user.owner.id]
}
