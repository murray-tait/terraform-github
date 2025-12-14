# Instructions for terraform-github

## Repository Purpose

This repository manages GitHub organization infrastructure as code using Terraform. It controls repository creation, branch protections, GitHub Actions environments, and AWS OIDC integration for automated deployments.

## Architecture Patterns

### Repository Module Pattern

Each repository is defined using either:

- **Standard module**: `modules/standard-github-repo` - provides opinionated defaults with AWS environment setup
- **Direct resources**: Like `adventofcode.tf` - for repositories needing custom configurations

The standard module automatically creates:

- Main branch with protection rules and required PR reviews
- Two GitHub Actions environments: `main` (deploy) and `main-plan` (planning)
- AWS OIDC role configuration for environment variables

### File Organization

- **`terraform/*.tf`**: One file per managed repository (e.g., `bash.tf`, `til.tf`, `this.tf`)
- **`this.tf`**: Manages the terraform-github repository itself (meta-repository pattern)
- **`backend.tf`**: S3 state backend using AWS profile `973963482762_TerraformStateAccess`

## Critical Workflows

### Development Workflow

```bash
make init    # Initialize Terraform (first time or after backend changes)
make plan    # Review changes before applying
make apply   # Apply Terraform changes
```

### Deployment Process

1. Changes merged to `main` trigger manual deployment via tag
2. Create tag: `make tag` generates timestamp-based tag `v2025.12.12.14.30`
3. Deploy via workflow_dispatch in `.github/workflows/tag-based-deployment.yml`
4. Tag format: `vYYYY.MM.DD.HH.MM` (strictly enforced in workflow validation)

### GitHub Token Authentication

Authentication uses `GITHUB_TOKEN` environment variable:

```bash
export GITHUB_TOKEN=$(cat ~/.config/gh/hosts.yml | yq '.[].oauth_token')
```

Token is also available as secret `THIS_GITHUB_TOKEN` in GitHub Actions.

## Project Conventions

### Branch Protection Standards

All repositories enforce:

- Required PR reviews (1 approver minimum)
- Dismiss stale reviews on new pushes
- Last push approval required
- Conversation resolution required
- Force push bypass: Only `/murray-tait` (owner)

### AWS Integration Pattern

Repositories with `environments = true` get:

- `AWS_REGION`: `eu-west-1` (default)
- `AWS_ROLE_TO_ASSUME`: `arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait`

### Drift Detection

Scheduled workflow runs daily at 05:17 UTC:

- Checks against tag `refs/tags/deployment/main`
- Creates GitHub issues when drift detected
- Uses centralized actions from `murray-tait/gha` repository

## Key Integration Points

### Centralized GitHub Actions

All workflows use reusable actions from `murray-tait/gha`:

- `configure-aws-credentials-file`: AWS OIDC authentication
- `plan`: Terraform planning with target support
- `drift-detection`: Automated drift reporting

### AWS State Management

- Backend: S3 bucket `org.murraytait.experiment.build.terraform`
- Profile: `973963482762_TerraformStateAccess`
- State key: `env/github-terraform/terraform.tfstate`
- Locking: Enabled via `use_lockfile = true`

## Adding New Repositories

Create a new `.tf` file in `terraform/` directory:

```terraform
# For standard repos with AWS integration:
module "new_repo" {
  source             = "./modules/standard-github-repo"
  name               = "repo-name"
  aws_role_to_assume = "arn:aws:iam::973963482762:role/Github-Actions-OIDC-murray-tait"
  review_user_ids    = [data.github_user.owner.id]
  environments       = true  # or false to skip AWS env setup
}

# For custom repos, see adventofcode.tf for direct resource pattern
```

Run `make plan` and `make apply` to create the repository.
