# Project 4 – Enterprise Azure Governance & Identity

## Overview

This project shows how Azure governance, identity, and security controls can be implemented using Terraform.

The goal was not simply to deploy resources, but to establish guardrails around how Azure resources are created, accessed, protected, and used.

The environment demonstrates:

- Resource organization using separate Resource Groups
- Role-Based Access Control (RBAC)
- Least-privilege access
- Azure Policy enforcement
- Resource Locks
- Azure Key Vault
- User-Assigned Managed Identity
- Passwordless workload authentication
- Key Vault access controlled through Azure RBAC

---

## Architecture

The environment separates Development and Production resources into dedicated Resource Groups.

```text
Azure Subscription
│
├── Development Resource Group
│   ├── Azure Policy
│   ├── RBAC
│   └── Test Resources
│
└── Production Resource Group
    ├── Key Vault
    ├── User-Assigned Managed Identity
    └── Protected Resources
```

This separation provides clearer administrative boundaries and allows different governance controls to be applied to different environments.

---

## Services Used

- Microsoft Azure
- Terraform
- Microsoft Entra ID
- Azure RBAC
- Azure Policy
- Azure Resource Locks
- Azure Key Vault
- Azure Managed Identities
- Azure CLI
- Azure Instance Metadata Service (IMDS)

---

# Resource Organization

Separate Resource Groups were created for Development and Production workloads.

This allows resources to be managed independently and provides clear boundaries for RBAC, policy assignments, and lifecycle management.

![Resource Groups](images/Resource%20Groups.png)

---

# Role-Based Access Control

Azure RBAC was used to control administrative access to resources.

Rather than assigning broad permissions at the subscription level, permissions were scoped closer to the resources where they were required. Trying to follow the principle of least privilege.

![RBAC Contributor](images/RBAC%20Contributor.png)

---

# Azure Policy

A custom Azure Policy was created to restrict resource deployment to the approved Azure region:

`East US`

The policy uses a `Deny` effect when resources attempt to deploy outside the approved region.

This provides an organizational guardrail that prevents users from accidentally deploying resources into unauthorized regions.

![Azure Policy](images/Azure%20Policy.png)

---

## Policy Enforcement Test

Policy enforcement was validated by attempting to deploy a resource into:

`West US`

Azure rejected the deployment because it violated the organization's location policy.

![Policy Denied](images/Policy%20Denied%20West%20US.png)

This demonstrates that governance controls are actively enforced rather than simply documented.

---

# Resource Protection

A Resource Lock was applied to protect critical infrastructure from accidental modification or deletion. Providing an additional safeguard beyond RBAC permissions.

![Resource Lock](images/Resource%20Lock.png)

---

# Azure Key Vault

Azure Key Vault was deployed to provide centralized storage for sensitive application information.

A test secret was created:

```text
Test-App-Secret
```

The secret was used to validate secure workload authentication and authorization.

---

# Managed Identity

A User-Assigned Managed Identity was attached to a Linux virtual machine.

Instead of storing credentials on the VM, the workload authenticates to Azure using its assigned identity.

```text
Linux VM
   │
   ▼
User-Assigned Managed Identity
   │
   ▼
Microsoft Entra ID
   │
   ▼
Azure RBAC
   │
   ▼
Azure Key Vault
```

This eliminates the need to store usernames, passwords, or application credentials directly on the virtual machine.

---

# Managed Identity Authentication Test

The Linux VM requested an Azure access token through the Azure Instance Metadata Service.

The token was then used to authenticate directly to Azure Key Vault.

The VM successfully retrieved:

```text
Project4-ManagedIdentity-Works
```

![Managed Identity Key Vault Success](images/Managed%20Identity%20Key%20Vault%20Success.png)

This validates the complete authentication path:

```text
VM
↓
Managed Identity
↓
Microsoft Entra ID
↓
Azure RBAC
↓
Key Vault
↓
Secret Retrieved
```

No username, password, or application secret was stored on the VM.

---

# Least-Privilege Validation

Successful authentication alone does not demonstrate least privilege.

The Managed Identity was therefore tested against an operation it should not be authorized to perform.

The VM attempted to create a new Key Vault secret.

Azure rejected the request with:

```text
Forbidden
ForbiddenByRbac
Caller is not authorized to perform action
```

![Key Vault RBAC Write Denied](images/KeyVault%20RBAC%20Write%20Denied.png)

This demonstrates that the workload can retrieve the information it requires while remaining unable to perform unauthorized administrative operations.

```text
Read Secret       → ALLOWED
Create Secret     → DENIED
```

---


# Business Value

This demonstrates controls commonly required in enterprise Azure environments.

The solution helps organizations:

- Reduce credential exposure
- Prevent unauthorized resource deployment
- Reduce accidental infrastructure deletion
- Enforce organizational cloud standards
- Apply least-privilege permissions
- Centralize sensitive information
- Improve security and governance consistency
- Reduce administrative overhead associated with credential management

---

# Key Takeaways

This project helped me realize that Azure security is not only about protecting individual resources.

A secure cloud environment requires multiple layers working together:

```text
Organization
     ↓
Governance
     ↓
Policy
     ↓
RBAC
     ↓
Identity
     ↓
Key Vault
     ↓
Workloads
```

The most important validation was demonstrating that an Azure VM could securely retrieve a Key Vault secret using Managed Identity while being denied permission to modify secrets. This provides a practical example of identity-based, least-privilege access in Azure.
