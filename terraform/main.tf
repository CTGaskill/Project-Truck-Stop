module "resource_group" {
  source = "../modules/azure-rg"
}

module "automation_account" {
  source = "../modules/azure-automation-account"
}

module "automation_runbook" {
  source = "../modules/azure-runbook"
}