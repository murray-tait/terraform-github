# terraform-github

Infrastructure as Code for managing GitHub organization repositories using Terraform.

## Overview

This repository manages the GitHub organization infrastructure, including:

- Repository creation and configuration
- Branch protection rules
- GitHub Actions environments and secrets
- AWS OIDC integration for CI/CD pipelines

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) ~> 6.8.3
- [GitHub CLI](https://cli.github.com/) for authentication
- AWS credentials with access to Terraform state bucket
- `yq` for parsing GitHub token from CLI config

## Quick Start

### Authentication

Set up GitHub token from your gh CLI configuration:

```bash
export GITHUB_TOKEN=$(cat ~/.config/gh/hosts.yml | yq '.[].oauth_token')
```

### Common Commands

```bash
# Initialize Terraform (first time or after backend changes)
make init

# Preview changes
make plan

# Apply changes
make apply

# Create deployment tag (timestamp-based)
make tag
```

## Repository Structure

```
.
├── terraform/
│   ├── *.tf              # One file per managed repository
│   ├── backend.tf        # S3 state backend configuration
│   ├── provider.tf       # GitHub provider setup
│   ├── versions.tf       # Provider version constraints
│   └── modules/
│       └── standard-github-repo/  # Reusable repository module
├── .github/
│   └── workflows/
│       ├── tag-based-deployment.yml    # Production deployment
│       └── scheduled-drift-check.yml   # Daily drift detection
└── Makefile              # Common Terraform operations
```

## Managing Repositories

### Using the Standard Module

For repositories requiring AWS integration and standard branch protections:

```terraform
module "my_repo" {
  source             = "./modules/standard-github-repo"
  name               = "my-repository"
  aws_role_to_assume = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids    = [data.github_user.owner.id]
  environments       = true  # Creates main and main-plan environments
}
```

The standard module provides:

- Public repository with issues, wiki, and discussions enabled
- Protected `main` branch requiring PR reviews
- Two GitHub Actions environments:
  - `main-plan`: For Terraform planning (no approval required)
  - `main`: For deployments (requires review)
- AWS environment variables: `AWS_REGION` and `AWS_ROLE_TO_ASSUME`

### Using Direct Resources

For repositories with custom requirements (see `adventofcode.tf`):

```terraform
resource "github_repository" "custom_repo" {
  name            = "custom-repo"
  has_discussions = false
  visibility      = "public"
}

resource "github_branch_protection" "custom_repo_main" {
  repository_id = github_repository.custom_repo.id
  pattern       = "main"
  # ... custom protection rules
}
```

## Deployment Process

### Tag-Based Deployment

1. Merge changes to `main` branch
2. Create a deployment tag:
   ```bash
   make tag  # Creates vYYYY.MM.DD.HH.MM format tag
   ```
3. Trigger deployment workflow manually via GitHub Actions UI
4. Select the created tag for deployment

**Tag Format**: `vYYYY.MM.DD.HH.MM` (e.g., `v2025.12.12.14.30`)

The deployment workflow validates:

- Tag exists in the repository
- Tag follows the required format
- Tag is based on the `main` branch

### Drift Detection

Automated drift detection runs daily at 05:17 UTC:

- Compares current state against `refs/tags/deployment/main`
- Creates GitHub issues when drift is detected
- Can be triggered manually via workflow_dispatch

## State Management

Terraform state is stored remotely in AWS S3:

- **Bucket**: `org.murraytait.experiment.build.terraform`
- **Key**: `env/github-terraform/terraform.tfstate`
- **Region**: `eu-west-1`
- **Profile**: `973963482762_TerraformStateAccess`
- **Locking**: Enabled

Ensure you have AWS credentials configured for the specified profile before running Terraform commands.

## Branch Protection Standards

All managed repositories enforce:

- ✅ Required pull request reviews (1 approver)
- ✅ Dismiss stale reviews on new push
- ✅ Require approval of most recent push
- ✅ Require conversation resolution
- ✅ Strict status checks
- ⚠️ Force push bypass: Owner only (`/murray-tait`)

## GitHub Actions Integration

### Centralized Workflows

This repository uses reusable actions from [`murray-tait/gha`](https://github.com/murray-tait/gha):

- `configure-aws-credentials-file`: AWS OIDC authentication with profile configuration
- `plan`: Terraform planning with optional resource targeting
- `drift-detection`: Automated drift reporting to GitHub issues

### Available Secrets

- `THIS_GITHUB_TOKEN`: Personal access token for GitHub API operations

## Adding a New Repository

1. Create a new `.tf` file in `terraform/` directory named after your repository
2. Define the repository using the standard module or direct resources
3. Run `make plan` to preview changes
4. Run `make apply` to create the repository
5. Create and push a deployment tag with `make tag`

Example (`terraform/myrepo.tf`):

```terraform
data "github_user" "owner" {
  username = "murray-tait"
}

module "myrepo" {
  source             = "./modules/standard-github-repo"
  name               = "myrepo"
  aws_role_to_assume = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids    = [data.github_user.owner.id]
  environments       = true
  aws_region         = "eu-west-1"  # optional, defaults to eu-west-1
}
```

## Troubleshooting

### State Lock Issues

If Terraform operations fail due to state locking:

```bash
cd terraform
terraform force-unlock <LOCK_ID>
```

### Authentication Failures

Verify your GitHub token is set correctly:

```bash
echo $GITHUB_TOKEN  # Should display your token
gh auth status      # Should show authenticated status
```

### Provider Version Updates

After updating provider versions in `versions.tf`:

```bash
make init  # Re-initialize to download new provider versions
```

## License

This infrastructure code is maintained by Murray Tait for managing personal GitHub repositories.
