# Project 5 - Enterprise Zero Trust Identity with Microsoft Entra ID

## Project Overview

This project demonstrates how to implement Zero Trust principles using Microsoft Entra ID and Conditional Access.

Instead of trusting every authentication attempt, access decisions are evaluated based on identity, location, and security requirements.

The goal was to simulate a real-world scenario in which a company wants to protect corporate resources by requiring additional verification before granting access.

---

## Business Scenario

A company has multiple employees working from different locations.

Leadership wants to reduce the risk of compromised accounts by implementing stronger authentication controls.

The requirements are:

- Allow employees to access company resources
- Require multifactor authentication (MFA)
- Apply policies to specific users instead of the entire organization
- Define trusted locations
- Replace default security settings with custom access policies

---

## Architecture

| Component | Purpose |
| --- | --- |
| Microsoft Entra ID | Identity management |
| Security Group | User grouping and policy targeting |
| Conditional Access | Authentication policy enforcement |
| Named Locations | Trusted geographic locations |
| Multifactor Authentication | Identity verification |
| Sign-in Logs | Authentication validation |

---

## Authentication Flow

```text
User signs in
        ↓
Microsoft Entra ID evaluates the request
        ↓
Conditional Access policy is applied
        ↓
Location is evaluated
        ↓
MFA requirement is enforced
        ↓
User identity is verified
        ↓
Access is granted
```

---

## Security Controls Implemented

### Security Group

A dedicated security group was created so policies could be applied to specific users rather than the entire organization.

---

### Conditional Access

A Conditional Access policy named:

```

Require-MFA-Outside-Trusted-Locations

```

was created to require multifactor authentication during sign-in.

---

### Named Locations

A trusted location named:

```

Trusted-US-Location

```

was configured to identify approved sign-in locations.

---

### Security Defaults

Security Defaults were disabled and replaced with custom Conditional Access policies.

This allowed the environment to enforce organization-specific authentication requirements instead of relying on Microsoft's default security configuration.

---

## Deployment Evidence

### Conditional Access Policy

![Conditional Access Policy](images/Conditional%20Access%20policy%20overview.png)

The policy was successfully configured and enabled.

---

### MFA Enforcement Validation

![MFA Sign-In Confirmed](images/MFA%20Sign%20In%20Confirmed.png)

Sign-in logs confirmed that the policy required MFA.

**Grant control:** MFA

**Result:** Success

---

### Trusted Location Configuration

![Named Locations](images/Named%20locations.png)

The United States was configured as a trusted location.

---

### Security Defaults Disabled

![Security Defaults Disabled](images/Security%20Defauls%20Disabled.png)

The environment was configured to use Conditional Access instead of Security Defaults.

---

## Security Benefits

| Security Control | Benefit |
| --- | --- |
| MFA | Reduces the risk of stolen passwords |
| Conditional Access | Enforces authentication requirements |
| Named Locations | Restricts access based on location |
| Security Groups | Limits policy scope |
| Sign-in Logs | Provides auditing and validation |

---

## Technologies Used

- Microsoft Entra ID
- Conditional Access
- Multifactor Authentication (MFA)
- Named Locations
- Azure Sign-in Logs
- Zero Trust Security

---

## Key Takeaways

- Passwords should not be the only security control.
- Authentication decisions should consider context.
- Security policies should be applied using the principle of least privilege.
- Zero Trust assumes that no authentication request should be trusted automatically.

---

**Another project completed while continuing to build practical Azure and cloud security skills.**