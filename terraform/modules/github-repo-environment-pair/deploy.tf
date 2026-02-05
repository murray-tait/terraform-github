resource "github_repository_environment" "deploy" {
  environment         = "${var.environment}-deploy"
  repository          = var.repository_name
  prevent_self_review = false
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
  reviewers {
    teams = var.review_teams
    users = var.review_user_ids
  }
}

resource "github_actions_environment_variable" "deploy" {
  for_each      = var.deploy_variables
  repository    = var.repository_name
  environment   = github_repository_environment.deploy.environment
  variable_name = each.key
  value         = each.value
}

resource "github_actions_environment_variable" "shared_deploy" {
  for_each      = var.shared_variables
  repository    = var.repository_name
  environment   = github_repository_environment.deploy.environment
  variable_name = each.key
  value         = each.value
}

resource "github_actions_environment_variable" "deploy_deployment_environment" {
  repository    = var.repository_name
  environment   = github_repository_environment.deploy.environment
  variable_name = "DEPLOYMENT_ENVIRONMENT"
  value         = var.environment
}

resource "github_actions_environment_secret" "deploy" {
  for_each        = nonsensitive(var.deploy_secrets)
  repository      = var.repository_name
  environment     = github_repository_environment.deploy.environment
  secret_name     = each.key
  plaintext_value = each.value
}
