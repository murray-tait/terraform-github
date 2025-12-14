module "parent_repository" {
  source                     = "./modules/standard-github-repo"
  name                       = "parent"
  aws_role_to_assume         = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids            = [data.github_user.owner.id]
  ops_info_discord_webhook   = var.ops_info_discord_webhook
  ops_alarms_discord_webhook = var.ops_alarms_discord_webhook
  deployment_discord_webhook = var.deployment_discord_webhook
}
