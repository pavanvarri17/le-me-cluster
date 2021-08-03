terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws      = "~> 3.40"
    null     = "~> 2.1"
    random   = "~> 2.2"
    local    = "~> 1.4"
    template = "~> 2.1"
   # kubernetes = "~>1.11"
    http = {
      source = "terraform-aws-modules/http"
      version = "2.4.1"
    }
  }
}