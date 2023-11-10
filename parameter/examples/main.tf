module "parameter" {
  source = "../"

  ssm_parameter = {
    "key" = {
      "name"  = "/database/rds"
      "type"  = "SecureString"
      "value" = "random_password"
    }
  }

  environment = "staging"
  
  tags = {
    Environment = "staging"
  }
}