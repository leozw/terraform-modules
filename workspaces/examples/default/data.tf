data "terraform_remote_state" "this" {
  count = var.data ? 1 : 0

  backend = "local"
  config = {
    path = "terraform.tfstate.d/${local.env_prd}/terraform.tfstate"
  }
}