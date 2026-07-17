# 05 — Cloud Fundamentals

[Back to 18-DevOps-and-Cloud](../README.md)

## Scope of This Lesson

Unlike Lessons 01–04, this lesson is **conceptual, not hands-on** — it doesn't create a real cloud account or spend real money on a cloud provider, consistent with this repository's "no real credentials" rule. Where a real cloud service would sit, this lesson instead **cross-references the real, runnable local demos already built earlier in this exact module**, since the underlying mechanics are the same — a real cloud deployment needs CI/CD, infrastructure-as-code, a reverse proxy/load balancer, and monitoring, and Lessons 01–04 built and verified real, working versions of all four, just running locally instead of against AWS/Azure/GCP.

## Service Models: IaaS, PaaS, SaaS

| Model | You manage | Provider manages | Example | This repository's closest hands-on equivalent |
|-------|-----------|-------------------|---------|------------------------------------------------|
| **IaaS** (Infrastructure as a Service) | OS, runtime, app, data | Physical hardware, virtualization, networking | AWS EC2, Azure VMs, GCP Compute Engine | [02-Infrastructure-as-Code-with-Terraform](../02-Infrastructure-as-Code-with-Terraform/README.md) — the exact same `init`/`plan`/`apply` workflow, pointed at a `local_file` instead of an `aws_instance` |
| **PaaS** (Platform as a Service) | App code, data | OS, runtime, scaling, patching | AWS Elastic Beanstalk, Azure App Service, Heroku | Any of the Spring Boot apps in [22-Projects](../../22-Projects/README.md) — `mvn spring-boot:run` locally is what a PaaS would do for you automatically on deploy |
| **SaaS** (Software as a Service) | Nothing infrastructure-related — just your data/config | Everything | Gmail, Salesforce, GitHub itself | N/A — this category is "someone else's finished application," not something this repository builds |

The further down this table you go, the less you manage and the less control you have — a genuine trade-off, not a strictly-better progression. A team that needs a specific OS-level tweak or an unusual runtime configuration may deliberately choose IaaS over PaaS for that control, even though PaaS is less operational work.

## Major Providers: Rough Service Equivalents

| Need | AWS | Azure | GCP |
|------|-----|-------|-----|
| Virtual machines | EC2 | Virtual Machines | Compute Engine |
| Managed containers | ECS / EKS | AKS | GKE |
| Serverless functions | Lambda | Azure Functions | Cloud Functions |
| Object storage | S3 | Blob Storage | Cloud Storage |
| Managed relational DB | RDS | Azure SQL Database | Cloud SQL |
| CDN | CloudFront | Azure CDN | Cloud CDN |
| IaC tool of choice | Terraform / CloudFormation | Terraform / Bicep | Terraform / Deployment Manager |

Terraform (used for real in [Lesson 02](../02-Infrastructure-as-Code-with-Terraform/README.md)) deliberately has first-class providers for all three — this is exactly why it's a common industry choice: the same tool and workflow work across providers, even though the underlying resource *types* still differ per provider.

## Serverless / Functions-as-a-Service (FaaS)

A function (not a whole running server) is deployed; the provider runs it only when triggered (an HTTP request, a queue message, a schedule) and bills per invocation/duration rather than for an always-on server. Trade-off: no idle-server cost, but a real, measurable **cold start** delay on the first invocation after a period of inactivity, and a hard per-invocation time limit — not a universal replacement for a long-running server, but a good fit for infrequent, bursty, or event-driven work.

## Scaling: Vertical vs. Horizontal

- **Vertical scaling**: give one server more CPU/RAM. Simple, but has a hard ceiling (the biggest instance type that exists) and usually requires downtime to resize.
- **Horizontal scaling**: add *more* servers and distribute load across them. This is exactly what [Lesson 03's nginx `upstream` block](../03-Reverse-Proxy-and-Load-Balancing-with-Nginx/README.md) demonstrated for real — three backend processes, load-balanced, with one killed mid-demo and the others transparently absorbing its traffic. A real cloud auto-scaling group does the same thing, just adding/removing whole VMs or containers automatically based on load, instead of the fixed three backends used in that lesson.

## Regions, Availability Zones, and the CAP Theorem

Cloud providers split infrastructure into **regions** (large, geographically separate areas — e.g., `us-east-1`) each containing multiple **availability zones** (physically separate data centers within a region, connected by low-latency links). Deploying across multiple availability zones (or regions) is how a real system survives a data-center-level outage — but doing so genuinely introduces the exact distributed-systems trade-off already demonstrated for real in [20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems](../../20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems/README.md) (two real servers, a real killed process simulating a network partition, genuine measurable data divergence) and again in [22-Projects/Advanced/Distributed-Order-Processing-System](../../22-Projects/Advanced/Distributed-Order-Processing-System/README.md)'s CP-over-AP design choice. Spreading a system across availability zones for resilience is not free — it's the same consistency/availability trade-off, just at a larger physical scale.

## The Shared Responsibility Model

Cloud security is split: the provider secures "the cloud itself" (physical data center security, host hypervisor patching, network infrastructure); the customer secures "what's *in* the cloud" (their own OS patching on IaaS, their application code, their data, their access control/IAM configuration). A cloud provider having a secure data center does **not** mean a customer's misconfigured storage bucket or weak IAM policy is automatically safe — most real cloud security incidents are customer-side misconfiguration, not provider-side breaches. This is a genuinely important distinction, not a formality: [16-Security](../../16-Security/README.md)'s own lessons (password hashing, SQL injection, authentication) are all squarely the customer's side of this line, regardless of which cloud (or no cloud) the app runs on.

## Cost Models

- **Pay-as-you-go / on-demand**: billed per second/hour of actual usage, no upfront commitment, most expensive per-unit but zero risk of paying for unused capacity.
- **Reserved / committed-use**: commit to a usage level for 1–3 years for a significant discount (often 30–70%) — a real cost-vs-flexibility trade-off, appropriate for predictable, steady-state workloads.
- **Spot / preemptible instances**: spare provider capacity at a steep discount, which the provider can reclaim with little notice — appropriate only for interruptible workloads (batch jobs, CI runners), never for anything that must stay up.

## Suggested Improvements / Next Steps

This lesson is the last one in `18-DevOps-and-Cloud`. A natural next step for anyone with access to a real (even free-tier) cloud account would be to take [Lesson 02's Terraform config](../02-Infrastructure-as-Code-with-Terraform/README.md) and point it at a real provider (`aws_instance`, `azurerm_linux_virtual_machine`, etc.) instead of the `local`/`random` providers used here — the `init`/`plan`/`apply`/`destroy` workflow itself would be identical.

**Previous lesson:** [04-Monitoring-with-Prometheus](../04-Monitoring-with-Prometheus/README.md)
