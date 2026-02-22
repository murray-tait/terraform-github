module "collaboration_import_repository" {
  source     = "./modules/standard-github-repo"
  name       = "collaboration-import"
  visibility = "private"
}
