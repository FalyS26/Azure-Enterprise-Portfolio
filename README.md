# Project 1 - Azure Enterprise Landing Zone with Terraform

## Overview

This project demonstrates how I deploy a secure Azure landing zone using Terraform Infrastructure as Code (IaC).

The goal was to build a reusable, enterprise-style Azure environment instead of manually creating resources through the Azure Portal.

The environment includes:

- Azure Resource Group
- Virtual Network
- Four Subnets
- Network Security Groups
- Azure Bastion
- Windows Server Virtual Machine
- Ubuntu Linux Virtual Machine
- Remote Terraform State stored in Azure Storage

---

## Project Highlights

- Built entirely with Terraform Infrastructure as Code (IaC)
- Enterprise-style Azure networking design
- Secure administration using Azure Bastion
- Private Windows and Linux virtual machines
- Remote Terraform state stored in Azure Storage
- Modular Terraform codebase
- Version controlled with Git and GitHub+

## Objectives

The objectives of this project was to:

- Learn Infrastructure as Code (IaC)
- Deploy Azure resources using Terraform
- Design a segmented virtual network
- Secure workloads using Network Security Groups
- Configure Azure Bastion for secure administration
- Store Terraform state remotely in Azure Storage
- Organize Terraform into reusable modules/files
- Use Git and GitHub for version control

---

## Technologies Used

- Microsoft Azure
- Terraform
- Azure CLI
- Visual Studio Code
- Git
- GitHub

---

## Architecture

## Azure Landing Zone Architecture 
![alt text](terraform/images/architecture-diagram.png)


### Network Design

![alt text](terraform/images/subnets.png)
| Resource | Configuration |
|----------|---------------|
| Resource Group | rg-azure-portfolio-dev-eastus-001 |
| Virtual Network | 10.0.0.0/16 |
| Management Subnet | 10.0.1.0/24 |
| Web Subnet | 10.0.2.0/24 |
| Application Subnet | 10.0.3.0/24 |
| Azure Bastion Subnet | 10.0.4.0/26 |

### Compute Resources

| Resource | Purpose |
|----------|---------|
| Windows Server 2022 VM | Management Server |
| Ubuntu 24.04 LTS VM | Application Server |
| Azure Bastion | Secure RDP/SSH access |

### Windows Management VM

![alt text](terraform/images/windows-vm.png)

---

### Ubuntu Application VM

![alt text](terraform/images/linux-vm.png)

## Azure Bastion    
![alt text](terraform/images/bastion.png)

### Network Security Groups

Each subnet has its own dedicated Network Security Group (NSG) to enforce network segmentation and follow the principle of least privilege.

| NSG | Rules |
|-----|-------|
| Management NSG | Allows internal Virtual Network management traffic |
![alt text](terraform/images/management-nsg.png)
| Web NSG | Allows HTTP (80) and HTTPS (443) from the Internet |
![alt text](terraform/images/web-nsg.png)
| Application NSG | Allows TCP 8080 traffic only from the Web subnet |
![alt text](terraform/images/application-nsg.png)


---

## Terraform Project Structure

To improve readability and maintainability, the Terraform configuration was split into multiple files based on resource type.

```text
01-Terraform-Landing-Zone/
│
├── terraform/
│   ├── backend.tf
│   ├── bastion.tf
│   ├── compute.tf
│   ├── main.tf
│   ├── network.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── security.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
```

### File Descriptions

| File | Purpose |
|------|---------|
| `provider.tf` | Configures the AzureRM provider and Terraform version |
| `main.tf` | Deploys the Azure Resource Group |
| `network.tf` | Creates the Virtual Network and subnets |
| `security.tf` | Creates Network Security Groups, rules, and subnet associations |
| `bastion.tf` | Deploys Azure Bastion, its subnet, and public IP |
| `compute.tf` | Deploys Windows and Linux virtual machines with their NICs |
| `variables.tf` | Defines reusable input variables |
| `outputs.tf` | Displays important deployment information after apply |
| `backend.tf` | Configures the Azure Storage remote backend |
| `terraform.tfvars.example` | Example variable file for future deployments |

---

## Deployment Process

### Prerequisites

Before deploying this project, ensured the following was installed:

- Microsoft Azure CLI
- Terraform
- Git
- Visual Studio Code
- An active Azure subscription

---

### Clone the Repository

```bash
git clone https://github.com/falys26/Azure-Enterprise-Portfolio.git
```

---

### Navigate to the Terraform Directory

```powershell
cd Projects/01-Terraform-Landing-Zone/terraform
```

---

### Authenticate to Azure

```powershell
az login
```

---

### Initialize Terraform

```powershell
terraform init
```

---

### Validate the Configuration

```powershell
terraform validate
```

---

### Review the Execution Plan

```powershell
terraform plan
```

---

### Deploy the Infrastructure

```powershell
terraform apply
```

---

### View Deployment Outputs

```powershell
terraform output
```

---

## Validation

After deployment, the infrastructure was validated using both Terraform and the Azure Portal.

### Terraform Validation

The following commands were used throughout the project:

```powershell
terraform validate
terraform plan
terraform apply
terraform output
terraform state list
```

Terraform successfully reported:

- No configuration errors
- Successful deployment of all resources
- Remote state migration to Azure Storage
- Correct deployment outputs
- Accurate Terraform state tracking

---

### Azure Validation

The following resources were verified in the Azure Portal:

- Resource Group
- Virtual Network
- Management Subnet
- Web Subnet
- Application Subnet
- Azure Bastion Subnet
- Network Security Groups
- Azure Bastion Host
- Windows Server VM
- Ubuntu Linux VM

---

### Connectivity Testing

The environment was successfully tested by:

- Connecting to the Windows VM using Remote Desktop through Azure Bastion
- Connecting to the Ubuntu VM using SSH through Azure Bastion
- Confirming both virtual machines only have private IP addresses
- Verifying Network Security Groups were associated with the correct subnets

---

## Lessons Learned

This project significantly improved my understanding of Azure infrastructure and Terraform. Some of the most valuable lessons I learned include:

### Infrastructure as Code

Before this project, I primarily deployed Azure resources through the Azure Portal. Building this landing zone with Terraform showed me how Infrastructure as Code makes deployments repeatable, consistent, and easier to maintain.

### Terraform State

One of the biggest concepts I learned was the importance of Terraform state. I learned that Terraform relies on the state file to remember which resources it manages, and why storing that state remotely in Azure Storage is critical for team collaboration and disaster recovery.

### Variables

Using variables instead of hardcoded values made the configuration much more reusable. Rather than editing multiple files, I can now deploy the same infrastructure to different environments by changing only a few values.

### Network Segmentation

Designing separate Management, Web, Application, and Bastion subnets helped me understand how enterprise Azure environments separate workloads and apply different security policies to each network segment.

### Azure Bastion

Deploying Azure Bastion demonstrated how administrators can securely manage virtual machines without exposing RDP or SSH directly to the internet.

### Terraform Project Organization

As the project grew, I learned the importance of organizing Terraform into separate files based on functionality. Splitting networking, security, compute, variables, outputs, and backend configuration made the project much easier to navigate and maintain.

### Git and Version Control

Throughout this project, I became more comfortable using Git to track infrastructure changes, organize commits, manage ignored files, and maintain a clean repository for collaboration.

---

## Future Improvements

If this landing zone were expanded into a production environment, I would implement the following enhancements:

- Azure Key Vault for secret management
- SSH key authentication for Linux virtual machines
- Microsoft Entra ID authentication for administrative access
- Azure Firewall for centralized network protection
- Azure Monitor and Log Analytics for monitoring and alerting
- Azure Backup for virtual machine protection
- Availability Zones for higher availability
- GitHub Actions for automated Terraform deployments (CI/CD)
- Azure Policy to enforce organizational standards
- Diagnostic settings for centralized logging

---

## Skills Demonstrated

- Terraform
- Microsoft Azure
- Infrastructure as Code (IaC)
- Azure Virtual Networking
- Azure Bastion
- Network Security Groups (NSGs)
- Remote Terraform State
- Azure Storage
- Linux Administration
- Windows Server Administration
- Git
- GitHub
- Azure CLI