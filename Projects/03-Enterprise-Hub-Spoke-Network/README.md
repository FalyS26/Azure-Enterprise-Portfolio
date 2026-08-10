# Azure Enterprise Hub-and-Spoke Network with Terraform

## Project Overview

I did this project to show the design and deployment of an enterprise-style Azure hub-and-spoke network architecture using Terraform.

The goal was to create a segmented Azure network in which application and internal workloads are separated into independent spoke virtual networks while centralized connectivity and traffic inspection are provided through a hub containing Azure Firewall.

Rather than allowing direct communication between the application and internal spokes, User-Defined Routes direct inter-spoke traffic through Azure Firewall.

The environment was deployed, tested, validated, and documented. 

---

## Architecture

The environment consists of three primary virtual networks:

| Network | Address Space | Purpose |
|---|---|---|
| Hub VNet | `10.10.0.0/16` | Central connectivity and Azure Firewall |
| Application Spoke | `10.20.0.0/16` | Web and application workloads |
| Internal Spoke | `10.30.0.0/16` | Internal/private workloads |

Traffic flow:

![High-level traffic flow](images/Traffic%20Flow.png)
```

The spokes are not directly peered to each other. Traffic requiring communication between the spokes is routed toward the Azure Firewall in the hub.

---

Resources Used

Azure Virtual Networks

Separate VNets provide workload isolation and allow different areas of the environment to have independent address spaces, subnets, security controls, and routing.

Azure Firewall provides centralized network traffic inspection and policy enforcement.

Instead of allowing the application and internal networks to communicate directly, traffic ws routed through the firewall before reaching the destination network.
Firewall private IP: 10.10.1.4

Firewall Policy

A network rule was configured to permit required traffic from the Application Spoke (10.20.0.0/16) toward the Internal Spoke (10.30.0.0/16).

Network Security Groups

Separate NSGs were used for different workload areas rather than relying on a single shared NSG. This provides more specific control and supports the principle of least privilege.
- Management NSG
- Web NSG
- Application NSG
- Internal NSG

VNet Peering

The hub is peered independently with each spoke.

Hub to and from Application Spoke
Hub to and from Internal Spoke
```

There is intentionally no direct Application-to-Internal spoke peering.

### User-Defined Routes

Route tables were used to influence the path taken by inter-spoke traffic.

Application traffic destined for the Internal Spoke:

```text
Destination: 10.30.0.0/16
Next Hop:     Virtual Appliance
Next Hop IP:  10.10.1.4
```

Internal traffic destined for the Application Spoke:

```text
Destination: 10.20.0.0/16
Next Hop:     Virtual Appliance
Next Hop IP:  10.10.1.4
```

This sends the relevant traffic toward Azure Firewall instead of relying on a direct spoke-to-spoke connection.

---

## Infrastructure as Code

The environment was deployed using Terraform rather than manually creating the infrastructure through the Azure Portal.

The Terraform configuration was separated into logical files to make the project easier to understand and maintain.

```text
terraform/
├── compute.tf
├── firewall-rules.tf
├── firewall.tf
├── main.tf
├── network.tf
├── outputs.tf
├── peering.tf
├── provider.tf
├── routing.tf
├── security.tf
├── terraform.tfvars
└── variables.tf
```

Terraform was used to manage:

- Resource groups
- Virtual networks
- Subnets
- Network Security Groups
- VNet peerings
- Azure Firewall
- Firewall Policy
- Route tables
- User-Defined Routes
- Test virtual machines
- Network interfaces

---

## Design Decisions

### Why Hub-and-Spoke?

A flat network becomes increasingly difficult to secure and manage as an environment grows.

Hub-and-spoke architecture provides separation between workloads while allowing shared networking and security services to be centralized.

The hub acts as the central networking/security layer while spokes contain individual workloads.


### Why UDRs?

VNet peering provides connectivity, but it does not by itself mean traffic will pass through a centralized security appliance.

UDRs allow the architecture to specify a desired next hop.

In this project, traffic between the workload networks is directed toward the Azure Firewall private IP.

### Why No Direct Spoke-to-Spoke Peering?

Directly peering every spoke with every other spoke becomes increasingly difficult to manage as the number of networks grows.


---

# Deployment Evidence

## Hub Resource Group

The hub resource group contains the centralized networking and security components, including Azure Firewall, Firewall Policy, the hub VNet, NSG, and firewall public IP.

![Hub Resource Group](images/HubNet%20Resource%20Group.png)

---

## Hub-and-Spoke Topology

Azure Resource Visualizer shows the hub VNet connected to the Application and Internal VNets.

![Hub-and-Spoke Topology](images/HubNet%20Vnet%20topology.png)

---

## Azure Firewall

Azure Firewall was deployed inside the hub network with private IP address `10.10.1.4`.

![Azure Firewall](images/HubNet%20Firewall.png)

---

## Firewall Policy

Firewall Policy provides centralized control over the traffic permitted between network segments.

![Firewall Policy](images/Firewall%20Policy.png)

The network rule allows approved traffic from:

```text
Source:      10.20.0.0/16
Destination: 10.30.0.0/16
Protocol:    TCP
```

---

# Routing Validation

## Application Spoke Route Table

The Application Spoke contains a route for the Internal Spoke address space.

```text
10.30.0.0/16
       ↓
Virtual Appliance
       ↓
10.10.1.4
       ↓
Azure Firewall
```

![Application Route Table](images/App%20Prod%20Route%20Table.png)

This route table is associated with the Application Spoke's web and application subnets.

---

## Internal Spoke Route Table

The Internal Spoke contains the corresponding route back toward the Application Spoke through the firewall.

```text
10.20.0.0/16
       ↓
Virtual Appliance
       ↓
10.10.1.4
       ↓
Azure Firewall
```

![Internal Route Table](images/Internal%20Route%20Table.png)

This provides a controlled return path through the centralized network architecture.

---

# Connectivity Testing

Deploying infrastructure successfully does not prove that the intended network path works.

Connectivity testing was therefore performed from a test VM in the Application Spoke toward a test VM in the Internal Spoke.

## Allowed Traffic — TCP 80

An HTTP request was sent from the Application Spoke to the Internal VM:

```bash
curl -v --connect-timeout 10 http://10.30.1.4
```

The request successfully returned:

```text
HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)

Project 3 - Internal Spoke reached through Azure Firewall
```

![Successful Routing](images/Successful%20Routing.png)

This demonstrated successful end-to-end HTTP connectivity across the designed network path.

---

## Unauthorized Port Test — TCP 8080

Connectivity was also tested against TCP port `8080`:

```bash
curl -v --connect-timeout 10 http://10.30.1.4:8080
```

The connection timed out:

```text
Failed to connect to 10.30.1.4 port 8080
Timeout was reached
```

![Denied Port 8080](images/Denied%20access%20port%208080.png)

This demonstrated that TCP/8080 connectivity was not permitted end-to-end while the required HTTP connectivity remained available.

---

# Security Model

The project uses multiple layers of network control.

```text
Workload
   │
   ▼
Network Security Group
   │
   ▼
User-Defined Route
   │
   ▼
Azure Firewall
   │
   ▼
Firewall Policy
   │
   ▼
Destination Network
```

This provides a stronger design than relying on a single security mechanism.

The architecture demonstrates:

- Network segmentation
- Centralized traffic inspection
- Least-privilege network access
- Workload-specific NSGs
- Controlled inter-spoke routing
- Private workload addressing
- Infrastructure as Code



---

# Skills Demonstrated

- Microsoft Azure
- Terraform
- Hub-and-Spoke Network Architecture
- Azure Virtual Networks
- Azure Firewall
- Azure Firewall Policy
- VNet Peering
- Network Security Groups
- User-Defined Routes
- Network Segmentation
- Traffic Inspection
- Infrastructure as Code
- Azure CLI
- Linux
- Network Troubleshooting
- Cloud Architecture

---

## Project Status

**Completed and validated.**

The infrastructure was successfully deployed and tested using Terraform and Azure CLI.

Required HTTP connectivity between workload networks was validated, while an unauthorized test port was confirmed unavailable.

The Terraform configuration remains in source control so the environment can be recreated when needed.