module "this_repository" {
  source          = "./modules/standard-github-repo"
  name            = "terraform-github"
  review_user_ids = [data.github_user.owner.id]
}

module "this_main_environment" {
  source          = "./modules/github-repo-environment-pair"
  repository_name = "terraform-github"
  environment     = "main"

  plan_variables = {
    "AWS_REGION"         = "eu-west-1"
    "AWS_ROLE_TO_ASSUME" = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  }

  plan_secrets = {
    "ops_info_discord_webhook"   = var.ops_info_discord_webhook
    "ops_alarms_discord_webhook" = var.ops_alarms_discord_webhook
    "deployment_discord_webhook" = var.deployment_discord_webhook
  }

  deploy_variables = {
    "AWS_REGION"         = "eu-west-1"
    "AWS_ROLE_TO_ASSUME" = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  }

  deploy_secrets = {
    "deployment_discord_webhook" = var.deployment_discord_webhook
  }
}
