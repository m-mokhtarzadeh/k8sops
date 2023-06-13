terraform {
  backend "s3" {
    bucket = "k8sops-terraform"
    key = "k8sops.tfstate"
    endpoint = "s3.ir-tbz-sh1.arvanstorage.ir"
    region = "ir-tbz"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
  }
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
		kubernetes = {
      source = "hashicorp/kubernetes"
			version = "2.21.1"
		}
		helm = {
      source = "hashicorp/helm"
			version = "2.10.1"
		}
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "1.0.1"
    }
  }
}

provider "kubernetes" {
  config_path = "${path.root}/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "${path.root}/.kube/config"
  }
}

module "minio" {
  source = "./modules/minio"
}

module "velero" {
  depends_on = [ 
    module.minio
   ]
  source = "./modules/velero"
  aws_access_key_id = "admin"
  aws_secret_access_key = "${module.minio.minio_admin_password}"
}

module "longhorn" {
  source = "./modules/longhorn"
}

module "elasticsearch" {
  depends_on = [module.longhorn]
  source = "./modules/elasticsearch"
}

module "monitoring" {
  depends_on = [module.longhorn]
  source = "./modules/monitoring"
}

module "nginx" {
  source = "./modules/nginx-ingress"
}

output "grafana_admin_dashboard_password" {
  value = module.monitoring.grafana_admin_dashboard_password
  sensitive = true
}

output "minio_admin_password" {
	value = "${module.minio.minio_admin_password}"
	sensitive = true
}
