terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "environment" {
  description = "Which environment this config is being generated for."
  type        = string
  default     = "dev"
}

variable "replica_count" {
  description = "How many server replicas this (fictional) deployment should have."
  type        = number
  default     = 2
}

# A real, no-cloud-account-needed resource: a randomly generated, human-readable
# name (e.g. "curious-falcon"), deterministic only in the sense that Terraform's
# STATE FILE remembers it -- re-running `terraform apply` without changes will
# NOT regenerate a new name, because Terraform compares desired vs. actual state
# and does nothing when they already match. This is the same core idea IaC tools
# use against real cloud APIs, demonstrated here without needing one.
resource "random_pet" "server_name" {
  length = 2
}

# Writes a REAL file to local disk -- standing in for what would be a real
# cloud resource (an EC2 instance, an Azure VM, a GCP bucket) if this were
# pointed at an actual cloud provider instead of the `local` provider. The
# file's content is generated from Terraform's own variables/resources, proving
# real interpolation, not just a static string.
resource "local_file" "app_config" {
  filename = "${path.module}/generated/app-config.json"
  content = jsonencode({
    environment   = var.environment
    server_name   = random_pet.server_name.id
    replica_count = var.replica_count
    generated_by  = "terraform"
  })
}

output "config_path" {
  value = local_file.app_config.filename
}

output "server_name" {
  value = random_pet.server_name.id
}
