# 🏢 Active Directory Database

Reference for Microsoft Active Directory fundamentals, administration, identity security, and authorized lab analysis.

## Core Concepts

- Domain
- Forest
- Organizational Unit (OU)
- Domain Controller (DC)
- Users and groups
- Group Policy (GPO)
- Kerberos
- LDAP
- DNS
- Authentication and authorization

## Common Administrative PowerShell

```powershell
Get-ADDomain
Get-ADForest
Get-ADUser -Filter *
Get-ADGroup -Filter *
Get-ADComputer -Filter *
```

These commands require the Active Directory PowerShell module and appropriate permissions.

## Defensive Focus

- Least privilege
- Separate administrative accounts
- Strong authentication
- Protected privileged groups
- Secure Group Policy
- Patch domain controllers
- Audit authentication events
- Review inactive accounts
- Monitor privileged-group membership
