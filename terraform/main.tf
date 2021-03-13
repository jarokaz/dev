terraform {
  required_version = ">=0.14"
  required_providers {
    google = "~> 3.5"
  }
  
  backend "gcs" {
    bucket = "jk-terraform-state"
    prefix = "ds-workbench"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "current" {}

data "google_compute_default_service_account" "default" {}

data "google_project" "project" {
  project_id = var.project_id
}

locals {
    network_name = var.network_name != "" ? var.network_name : module.vpc[0].network_name
    subnet_name  = var.network_name != "" ? var.subnet_name: module.vpc[0].subnet_name
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"

  project_id  = data.google_client_config.current.project
  disable_services_on_destroy = false
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}

module "vpc" {
    source       = "./vpc"
    region       = var.region
    network_name =  "${var.name_prefix}-network"
    subnet_name  =  "${var.name_prefix}-subnet"
    count        = var.network_name != "" ? 0 : 1
}

module "dlvm" {
    source  = "./dlvm"
    name            = "${var.name_prefix}-vm"
    zone            = var.zone
    network         = local.network_name
    subnetwork      = local.subnet_name
    machine_type    = var.machine_type
    image_family    = var.image_family
    service_account = data.google_compute_default_service_account.default.email
}

output "project" {
  value = data.google_client_config.current.project
}

output "dlvm_network_name" {
    value = local.network_name
}

output "dlvm_subnet_name" {
    value = local.subnet_name
}