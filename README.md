# AWS EKS Kubernetes Platform (Terraform)

> Production-style Amazon EKS cluster with a managed node group and IRSA — all provisioned with Terraform.
> **Author:** Muhammad Ahmad · **IaC:** Terraform · **Cloud:** AWS

![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EKS%20%7C%20IAM%20%7C%20VPC-FF9900?logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.30-326CE5?logo=kubernetes&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Overview

A ready-to-use **Amazon EKS** platform:

- **Dedicated VPC** with public + private subnets across 2 AZs, NAT Gateway, and the subnet tags EKS needs for load balancers.
- **EKS control plane** (managed by AWS) with public + private endpoint access.
- **Managed node group** running worker nodes in **private subnets**, with autoscaling bounds.
- **IRSA** — an IAM OIDC provider so pods can assume fine-grained IAM roles (no node-wide credentials).

## 🏗️ Architecture

```mermaid
flowchart TB
    Dev([Developer / kubectl])

    subgraph VPC["AWS VPC"]
        subgraph CP["EKS Control Plane (AWS-managed)"]
            API[Kubernetes API Server]
        end
        subgraph Priv["Private Subnets · 2 AZs"]
            N1[Worker Node AZ-a]
            N2[Worker Node AZ-b]
        end
        NAT[NAT Gateway]
    end

    Dev -->|HTTPS kubectl| API
    API --> N1
    API --> N2
    N1 -.image pull.-> NAT
    N2 -.image pull.-> NAT
    OIDC[IAM OIDC / IRSA] -.pod IAM roles.-> N1
```

## 🚀 Deploy

**Prerequisites:** Terraform ≥ 1.5, AWS credentials, `kubectl`, `aws` CLI.

```bash
cd terraform
terraform init
terraform apply   # provisioning EKS takes ~15 minutes
```

Connect `kubectl`:

```bash
$(terraform output -raw update_kubeconfig_command)
kubectl get nodes
```

## 🧹 Clean up

```bash
terraform destroy
```

## 💰 Cost note

The **EKS control plane (~$0.10/hr)**, NAT Gateway, and worker EC2 instances bill hourly and are **not free-tier**. Destroy when finished.

## 🔐 Production hardening (next steps)

- Restrict the API endpoint to private + known CIDRs.
- Add the **AWS Load Balancer Controller** and **cluster-autoscaler** via IRSA.
- Add managed add-ons (CoreDNS, kube-proxy, VPC CNI) with pinned versions.
- Enable control-plane logging to CloudWatch.

---

*Built and maintained by **Muhammad Ahmad**.*
