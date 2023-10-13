terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }

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

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token     = var.terratowns_access_token
}

module "home_arcanum_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.teacherseat_user_uuid
  public_path     = var.arcanum.public_path
  content_version = var.arcanum.content_version
}

resource "terratowns_home" "home" {
  name            = "How to play Arcanum in 2023!"
  description     = <<DESCRIPTION
Arcanum is a game from 2001 that shipped with a lot of bugs.
Modders have removed all the originals making this game really fun
to play (despite that old look graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESCRIPTION
  domain_name     = module.home_arcanum_hosting.domain_name
  town            = "gamers-grotto"
  content_version = var.arcanum.content_version
}

module "home_seashore_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.teacherseat_user_uuid
  public_path     = var.seashore.public_path
  content_version = var.seashore.content_version
}

resource "terratowns_home" "home_seashore" {
  name            = "Exploring nature at seashore "
  description     = <<DESCRIPTION
Come along and enjoy natural beauty at beautiful sea shores.
DESCRIPTION
  domain_name     = module.home_seashore_hosting.domain_name
  town            = "the-nomad-pad"
  content_version = var.seashore.content_version
}
