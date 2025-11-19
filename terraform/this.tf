resource "github_repository" "terraform_github" {
  name            = "terraform-github"
  has_discussions = false
  has_downloads   = true
  has_projects    = true
  has_wiki        = true
  has_issues      = true
}

resource "github_branch" "terraform_github_main" {
  repository = github_repository.terraform_github.name
  branch     = "main"
}

resource "github_branch_default" "terraform_github" {
  repository = github_repository.terraform_github.name
  branch     = github_branch.terraform_github_main.branch
}

resource "github_branch_protection" "main" {
  repository_id                   = github_repository.terraform_github.id
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

resource "github_repository_ruleset" "terraform_github_main" {
  name        = "main"
  repository  = github_repository.terraform_github.name
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
    required_signatures     = false

    pull_request {
      required_review_thread_resolution = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false


    }
  }
}

resource "github_repository_environment" "build_aws_main" {
  environment         = "main"
  repository          = github_repository.terraform_github.name
  prevent_self_review = false
  reviewers {
    users = [data.github_user.owner.id]
  }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

data "github_user" "owner" {
  username = "murray-tait"
}

resource "github_actions_environment_variable" "terraform_github_main_aws_region" {
  repository    = github_repository.terraform_github.name
  environment   = github_repository_environment.build_aws_main.environment
  variable_name = "AWS_REGION"
  value         = "eu-west-1"
}

resource "github_actions_environment_variable" "terraform_github_main_aws_role_to_assume" {
  repository    = github_repository.terraform_github.name
  environment   = github_repository_environment.build_aws_main.environment
  variable_name = "AWS_ROLE_TO_ASSUME"
  value         = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
}

import {
  to = github_actions_environment_variable.terraform_github_main_aws_role_to_assume
  id = "terraform-github:main:AWS_ROLE_TO_ASSUME"
}
