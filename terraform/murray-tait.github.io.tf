module "murray_tait_github_io_repository" {
  source     = "./modules/standard-github-repo"
  name       = "murray-tait.github.io"
  visibility = "public"
  pages      = true
}

import {
  to = module.murray_tait_github_io_repository.github_repository.this
  id = "murray-tait.github.io"
}

import {
  to = module.murray_tait_github_io_repository.github_branch.this_main
  id = "murray-tait.github.io:main"
}

import {
  to = module.murray_tait_github_io_repository.github_branch_default.this
  id = "murray-tait.github.io"
}

