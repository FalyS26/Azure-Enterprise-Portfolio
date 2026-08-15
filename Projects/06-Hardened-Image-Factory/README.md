# 🚀 Project 6 – Hardened Image Factory

## 📌 Project Overview

For Project 6, I wanted to learn how enterprise organizations create secure, standardized virtual machine images instead of manually configuring every server after deployment.

The goal was simple:

**Build one approved and security-hardened Ubuntu image that can be reused throughout the entire environment.**

I used **Terraform** to deploy the Azure infrastructure and **HashiCorp Packer** to automatically build, harden, and publish the image to **Azure Compute Gallery**.

This project also introduced me to **CI/CD concepts**, image versioning, and automated image management.

---

## 🎯 Business Problem

Imagine a company with 500 virtual machines.

If every engineer builds servers manually, you eventually end up with:

- Different patch levels
- Different security configurations
- Unnecessary services running
- Inconsistent SSH settings
- Configuration drift

The solution is to create a **golden image**.

Instead of configuring every server individually, every future VM starts from the same approved baseline.

---

## 🏗️ Architecture

```text
Ubuntu 22.04 LTS (Marketplace)
                ↓
         HashiCorp Packer
                ↓
     Temporary Azure Build VM
                ↓
          hardening.sh
                ↓
        Security Controls
                ↓
      Azure Compute Gallery
                ↓
      ubuntu-hardened-base
                ↓
        Future VM Deployments
```

---

## 🛠️ Technologies Used

- Microsoft Azure
- Terraform
- HashiCorp Packer
- Azure Compute Gallery
- Ubuntu 22.04 LTS
- Bash
- GitHub
- GitHub Actions
- Azure CLI

---

# 🔨 Infrastructure Created with Terraform

## Resource Group

**rg-imagefactory-prod-eastus-001**

Purpose:

A dedicated resource group for the image factory.

---

## Azure Compute Gallery

**acgenterpriseimages001**

Purpose:

A centralized repository for approved virtual machine images.

Think of it as a company library that stores every approved server image.

---

## Image Definition

**ubuntu-hardened-base**

Configuration:

- OS Type: Linux
- OS State: Generalized
- VM Generation: V2

Purpose:

Defines the operating system family and image template that future image versions will follow.

---

# 🔐 Security Hardening

The `hardening.sh` script automatically applied several security controls.

---

## Operating System Updates

```bash
apt-get update
apt-get upgrade
```

Purpose:

Installed the latest operating system updates.

Security benefit:

Reduces vulnerabilities caused by outdated software.

---

## Audit Logging

```bash
auditd
```

Purpose:

Installed and enabled Linux audit logging.

Security benefit:

Creates a record of security-related system activity.

---

## Disable Root SSH Login

```bash
PermitRootLogin no
```

Purpose:

Prevents administrators from logging in directly as root.

Security benefit:

Protects the most privileged Linux account.

---

## Disable Password Authentication

```bash
PasswordAuthentication no
```

Purpose:

Disables password-based SSH authentication.

Security benefit:

Reduces the risk of brute-force password attacks.

---

## Remove Unnecessary Packages

```bash
apt autoremove
apt clean
```

Purpose:

Removes unused software.

Security benefit:

Reduces the attack surface.

---

# 🏭 Packer Build Process

Packer automatically performed the following steps:

1. Connected to Azure.
2. Created a temporary resource group.
3. Deployed a temporary Ubuntu VM.
4. Connected to the VM through SSH.
5. Executed `hardening.sh`.
6. Applied security configurations.
7. Generalized the virtual machine.
8. Captured the image.
9. Published the image to Azure Compute Gallery.
10. Deleted all temporary resources.

---

# ⚠️ Troubleshooting

## Issue #1: Invalid Subscription

### Error

```text
SubscriptionNotFound
```

### Resolution

Updated the Packer configuration with the correct Azure subscription ID.

---

## Issue #2: VM Quota Exceeded

### Error

```text
QuotaExceeded
```

### Resolution

Reviewed available VM quotas using:

```bash
az vm list-usage --location eastus -o table
```

---

## Issue #3: VM SKU Not Available

### Error

```text
SkuNotAvailable
```

### Resolution

Changed the build VM from:

```text
Standard_D2s_v5
```

To:

```text
Standard_D2as_v7
```

---

# ✅ Successful Build

The final image was successfully published.

| Component | Value |
| --- | --- |
| Gallery | acgenterpriseimages001 |
| Image | ubuntu-hardened-base |
| Version | 1.0.0 |
| Region | East US |
| OS | Ubuntu 22.04 |
| VM Generation | V2 |

---

# 📸 Screenshots

## Azure Compute Gallery

![Azure Compute Gallery](images/azure-compute-gallery.png)

---

## Ubuntu Hardened Image Definition

![Image Definition](images/image-definition.png)

---

## Successful Packer Build

![Packer Build](images/packer-build-success.png)

---

## Image Version 1.0.0

![Image Version](images/image-version.png)

---

# 🔄 Future Improvements

The next phase of this project will include:

- GitHub Actions
- CI/CD pipeline automation
- Automated image versioning
- Vulnerability scanning
- Multi-region image replication

---

# 💡 Key Takeaway

This project taught me that cloud security doesn't start after a server is deployed.

It starts before the server is ever created.

Instead of securing every VM individually, security becomes part of the image itself.

Every future server now starts from the same secure and approved baseline.