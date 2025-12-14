module "parent_repository" {
  source             = "./modules/standard-github-repo"
  name               = "parent"
  aws_role_to_assume = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids    = [data.github_user.owner.id]
}

import {
  id = "parent"
  to = module.parent_repository.github_repository.this
}

import {
  id = "parent:8456580"
  to = module.parent_repository.github_repository_ruleset.this_main
}
