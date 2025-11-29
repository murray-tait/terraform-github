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

resource "github_branch_protection" "this_main" {
  repository_id                   = github_repository.this.id
  allows_deletions                = false
  allows_force_pushes             = false
  enforce_admins                  = false
  lock_branch                     = false
  pattern                         = "main"
  require_conversation_resolution = true
  require_signed_commits          = false
  required_linear_history         = false
  force_push_bypassers            = ["/murray-tait", ]

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_last_push_approval      = true
    required_approving_review_count = 1

  }
}

resource "github_repository_ruleset" "this_main" {
  name        = "main"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = 4
    actor_type  = "RepositoryRole"
    bypass_mode = "always"

  }

  rules {
    creation                = true
    update                  = true
    deletion                = true
    required_linear_history = false
    required_signatures     = true

    pull_request {
      required_review_thread_resolution = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
    }
  }
}
