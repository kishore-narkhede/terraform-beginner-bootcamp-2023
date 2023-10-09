terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "KishoreOrg"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  cloud {
    organization = "KishoreOrg"
    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "aws" {
}
