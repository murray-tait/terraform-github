module "devcontainer_repository" {
  source                     = "./modules/standard-github-repo"
  name                       = ".devcontainer"
  aws_role_to_assume         = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids            = [data.github_user.owner.id]
  ops-info-discord-webhook   = var.ops-info-discord-webhook
  ops-alarms-discord-webhook = var.ops-alarms-discord-webhook
  deployment-discord-webhook = var.deployment-discord-webhook
}
