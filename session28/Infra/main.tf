terraform {
  backend "s3" {
    bucket = "k8sops-terraform"
    key = "terraform.tfstate"
    endpoint = "s3.ir-tbz-sh1.arvanstorage.ir"
    region = "ir-tbz"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
  }
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.39.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}