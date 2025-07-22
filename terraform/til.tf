resource "github_repository" "til" {
  name            = "til"
  has_discussions = false
  has_downloads   = true
  has_projects    = true
  has_wiki        = true
  has_issues      = true
}

resource "github_branch" "til_main" {
  repository = github_repository.til.name
  branch     = "main"
}

resource "github_branch_default" "til" {
  repository = github_repository.til.name
  branch     = github_branch.til_main.branch
}

resource "github_branch_protection" "til_main" {
  repository_id                   = github_repository.til.id
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

resource "github_repository_ruleset" "til_main" {
  name        = "main"
  repository  = github_repository.til.name
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
