module "aws_org_repository" {
  source = "./modules/standard-github-repo"
  name   = "aws_org"
}

module "aws_org_main_environment" {
  source          = "./modules/github-repo-environment-pair"
  repository_name = "aws_org"
  environment     = "main"
  review_user_ids = [data.github_user.owner.id]

  plan_variables = {
    "AWS_REGION"                         = "eu-west-1"
    "AWS_ROLE_TO_ASSUME_TERRAFORM"       = "arn:aws:iam::453254632971:role/Github-Actions-OIDC-murray-tait"
    "AWS_ROLE_TO_ASSUME_TERRAFORM_STATE" = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-org"
  }

  plan_secrets = {
    "info_discord_webhook"       = var.info_discord_webhook
    "alarms_discord_webhook"     = var.alarms_discord_webhook
    "deployment_discord_webhook" = var.deployment_discord_webhook
  }

  deploy_variables = {
    "AWS_REGION"                         = "eu-west-1"
    "AWS_ROLE_TO_ASSUME_TERRAFORM"       = "arn:aws:iam::453254632971:role/Github-Actions-OIDC-murray-tait"
    "AWS_ROLE_TO_ASSUME_TERRAFORM_STAGE" = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-org"
  }

  deploy_secrets = {
    "deployment_discord_webhook" = var.deployment_discord_webhook
  }
}

import {
  to = module.aws_org_repository.github_repository.this
  id = "aws_org"
}

import {
  to = module.aws_org_main_environment.github_repository_environment.plan
  id = "aws_org:main-plan"
}

import {
  to = module.aws_org_main_environment.github_actions_environment_variable.plan["AWS_REGION"]
  id = "aws_org:main-plan:AWS_REGION"
}

import {
  to = module.aws_org_main_environment.github_actions_environment_variable.plan["AWS_ROLE_TO_ASSUME_TERRAFORM"]
  id = "aws_org:main-plan:AWS_ROLE_TO_ASSUME_TERRAFORM"
}

import {
  to = module.aws_org_main_environment.github_actions_environment_variable.plan["AWS_ROLE_TO_ASSUME_TERRAFORM_STATE"]
  id = "aws_org:main-plan:AWS_ROLE_TO_ASSUME_TERRAFORM_STATE"
}

import {
  to = module.aws_org_main_environment.github_actions_environment_variable.plan_deployment_environment
  id = "aws_org:main-plan:DEPLOYMENT_ENVIRONMENT"
}

