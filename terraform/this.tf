module "this_repository" {
  source = "./modules/standard-github-repo"
  name   = "terraform-github"
}

module "this_main_environment" {
  source          = "./modules/github-repo-environment-pair"
  repository_name = "terraform-github"
  environment     = "main"
  review_user_ids = [data.github_user.owner.id]

  shared_variables = {
    "AWS_REGION"         = "eu-west-1"
    "AWS_ROLE_TO_ASSUME" = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  }

  plan_secrets = {
    "INFO_DISCORD_WEBHOOK"       = var.info_discord_webhook
    "ALARMS_DISCORD_WEBHOOK"     = var.alarms_discord_webhook
    "DEPLOYMENT_DISCORD_WEBHOOK" = var.deployment_discord_webhook
  }

  deploy_secrets = {
    "DEPLOYMENT_DISCORD_WEBHOOK" = var.deployment_discord_webhook
  }
}
