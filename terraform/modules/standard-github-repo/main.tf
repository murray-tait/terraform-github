resource "github_repository" "this" {
  name            = var.name
  has_discussions = false
  has_downloads   = true
  has_projects    = true
  has_wiki        = true
  has_issues      = true
  visibility      = "public"
}

resource "github_branch" "this_main" {
  repository = github_repository.this.name
  branch     = "main"
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = github_branch.this_main.branch
}

resource "github_repository_environment" "build_aws_main" {
  count               = var.environments ? "1" : "0"
  environment         = "main"
  repository          = github_repository.this.name
  prevent_self_review = false
  reviewers {
    users = var.review_user_ids
  }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_actions_environment_variable" "this_main_aws_region" {
  count         = var.environments ? "1" : "0"
  repository    = github_repository.this.name
  environment   = github_repository_environment.build_aws_main[0].environment
  variable_name = "AWS_REGION"
  value         = var.aws_region
}

resource "github_actions_environment_variable" "this_main_aws_role_to_assume" {
  count         = var.environments ? "1" : "0"
  repository    = github_repository.this.name
  environment   = github_repository_environment.build_aws_main[0].environment
  variable_name = "AWS_ROLE_TO_ASSUME"
  value         = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
}

resource "github_repository_environment" "build_aws_main_plan" {
  count               = var.environments ? "1" : "0"
  environment         = "main-plan"
  repository          = github_repository.this.name
  prevent_self_review = false
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_actions_environment_variable" "this_main_plan_aws_region" {
  count         = var.environments ? "1" : "0"
  repository    = github_repository.this.name
  environment   = github_repository_environment.build_aws_main_plan[0].environment
  variable_name = "AWS_REGION"
  value         = var.aws_region
}

resource "github_actions_environment_variable" "this_main_plan_aws_role_to_assume" {
  count         = var.environments ? "1" : "0"
  repository    = github_repository.this.name
  environment   = github_repository_environment.build_aws_main_plan[0].environment
  variable_name = "AWS_ROLE_TO_ASSUME"
  value         = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
}
