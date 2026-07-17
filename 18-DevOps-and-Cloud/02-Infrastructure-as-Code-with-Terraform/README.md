# 02 — Infrastructure as Code with Terraform

[Back to 18-DevOps-and-Cloud](../README.md)

## What This Lesson Covers

- **Infrastructure as Code (IaC)**: describing infrastructure (servers, config, storage) in a text file that a tool can create/update/destroy for you, rather than clicking through a console or SSH-ing in to run commands by hand. The same file is version-controlled, reviewable, and reproducible.
- **Terraform's core lifecycle**: `terraform init` (download providers), `terraform plan` (compute and show a diff between desired and actual state, without changing anything), `terraform apply` (actually make the change), `terraform destroy` (tear it down).
- **State**: Terraform remembers what it created in `terraform.tfstate`. This is *why* re-running `plan`/`apply` with no config changes reports "No changes" instead of recreating everything from scratch — Terraform compares the config against its recorded state, not against nothing.
- **No cloud account or Docker needed**: this lesson uses the `local` and `random` providers, which manage real local files and generate real random values — genuine, runnable infrastructure-as-code, without needing AWS/Azure/GCP credentials (which this repository's "no real credentials" rule and this session's no-Docker constraint both rule out anyway). The exact same `init`/`plan`/`apply`/`destroy` workflow is what you'd use against a real `aws_instance` or `azurerm_virtual_machine` resource instead.

## Files

- [`main.tf`](main.tf) — a `random_pet` (a real, generated human-readable name) and a `local_file` (a real JSON config file written to disk, built from that name plus two variables).

## How to Run

```bash
cd 18-DevOps-and-Cloud/02-Infrastructure-as-Code-with-Terraform
terraform init
terraform plan
terraform apply -auto-approve
cat generated/app-config.json    # the real file Terraform just created
terraform destroy -auto-approve
```

## Verified Behavior (Real Output)

**`apply` genuinely creates a real file on disk:**
```
$ terraform apply -auto-approve
random_pet.server_name: Creation complete after 0s [id=amazed-sturgeon]
local_file.app_config: Creation complete after 0s [id=335ca0028be30c56327c9a1655a84be0a6a7c988]

Outputs:
config_path = "./generated/app-config.json"
server_name = "amazed-sturgeon"

$ cat generated/app-config.json
{"environment":"dev","generated_by":"terraform","replica_count":2,"server_name":"amazed-sturgeon"}
```

**Re-running `plan` with the same config reports no changes — proving state tracking actually works, not just that the tool ran:**
```
$ terraform plan
No changes. Your infrastructure matches the configuration.
```

**Changing a variable produces a real, precise diff** (`terraform plan -var="environment=production" -var="replica_count=5"`):
```
# local_file.app_config must be replaced
~ content = jsonencode(
    ~ {
        ~ environment   = "dev" -> "production"
        ~ replica_count = 2 -> 5
      } # forces replacement
  )
Plan: 1 to add, 0 to change, 1 to destroy.
```

**`destroy` genuinely removes the file — confirmed by listing the directory afterward, not just trusting Terraform's own success message:**
```
$ terraform destroy -auto-approve
local_file.app_config: Destruction complete after 0s
random_pet.server_name: Destruction complete after 0s
Destroy complete! Resources: 2 destroyed.

$ ls generated/
(empty)
```

## Suggested Improvements / Next Steps

Continue to [03-Reverse-Proxy-and-Load-Balancing-with-Nginx](../03-Reverse-Proxy-and-Load-Balancing-with-Nginx/README.md) — a real Nginx instance, running natively (no Docker), load-balancing across multiple real backend server processes.

**Previous lesson:** [01-CI-CD-with-GitHub-Actions](../01-CI-CD-with-GitHub-Actions/README.md)
**Next lesson:** [03-Reverse-Proxy-and-Load-Balancing-with-Nginx](../03-Reverse-Proxy-and-Load-Balancing-with-Nginx/README.md)
