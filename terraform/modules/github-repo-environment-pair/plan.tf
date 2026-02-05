resource "github_repository_environment" "plan" {
  environment         = "${var.environment}-plan"
  repository          = var.repository_name
  prevent_self_review = false
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_actions_environment_variable" "plan" {
  for_each      = var.plan_variables
  repository    = var.repository_name
  environment   = github_repository_environment.plan.environment
  variable_name = each.key
  value         = each.value
}

resource "github_actions_environment_variable" "shared_plan" {
  for_each      = var.shared_variables
  repository    = var.repository_name
  environment   = github_repository_environment.plan.environment
  variable_name = each.key
  value         = each.value
}

resource "github_actions_environment_variable" "plan_deployment_environment" {
  repository    = var.repository_name
  environment   = github_repository_environment.plan.environment
  variable_name = "DEPLOYMENT_ENVIRONMENT"
  value         = var.environment
}

resource "github_actions_environment_secret" "plan" {
  for_each    = nonsensitive(var.plan_secrets)
  repository  = var.repository_name
  environment = github_repository_environment.plan.environment
  secret_name = each.key

  plaintext_value = each.value
}
