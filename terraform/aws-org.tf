# module "this_repository" {
#   source             = "./modules/standard-github-repo"
#   name               = "aws_org"
#   aws_role_to_assume = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
#   review_user_ids    = [data.github_user.owner.id]
# }
