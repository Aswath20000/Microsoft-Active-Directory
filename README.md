# Active Directory Infrastructure Lab – Windows Server 2022

An enterprise-style on-premises Active Directory lab built using Windows Server 2022 in VMware Workstation Pro.  
This project demonstrates structured Organizational Unit (OU) design, Role-Based Access Control (RBAC), Group Policy enforcement, centralized file and printer services, and validation from domain-joined client systems.

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Architecture](#architecture)
4. [Active Directory Design](#active-directory-design)
5. [Users and Groups (RBAC)](#users-and-groups-rbac)
6. [File Server Configuration](#file-server-configuration)
7. [Group Policy Implementation](#group-policy-implementation)
8. [Drive Mapping via GPO](#drive-mapping-via-gpo)
9. [USB Security Enforcement](#usb-security-enforcement)
10. [Printer Deployment](#printer-deployment)
11. [Validation and Testing](#validation-and-testing)
12. [Conclusion](#conclusion)

---

## Overview

This project simulates a real-world enterprise Active Directory environment commonly managed by system administrators.  
It focuses on centralized identity management, access control, security policy enforcement, and automated resource deployment using Microsoft Windows Server technologies.

The lab emphasizes **practical administration skills** rather than theoretical configuration.

---

## Prerequisites

Before setting up the lab, ensure the following software and tools are available:

1. **VMware Workstation Pro**
2. **Windows Server 2022 ISO**
3. **Windows 10 / Windows 11 ISO**
4. **Basic networking knowledge (DNS, DHCP, IP addressing)**
5. **PowerShell (built into Windows Server)**

---

## Architecture

### Domain

### Virtual Machines

| VM Name | Role |
|------|------|
| DC01 | Domain Controller, DNS, Group Policy |
| FS01 | File Server, Print Server |
| CLIENT01 | Domain-joined workstation |

<img src="./screenshots/architecture-diagram.png" width="700">

---

## Active Directory Design

### Organizational Unit (OU) Structure

A structured OU hierarchy was implemented to enable scalable administration and clean Group Policy targeting.

corp.local
├── Admins
├── Servers
├── Workstations
├── CorpUsers
│ ├── Finance
│ ├── HR
│ └── IT
└── Groups


**OU Design Rationale**
- **Admins** – Administrative user accounts  
- **Servers** – Member servers (File / Print servers)  
- **Workstations** – Domain-joined client systems  
- **CorpUsers** – Standard users organized by department  
- **Groups** – Security groups used for RBAC and policy targeting  

<img src="./Screenshots/ou-structure.png" width="700">

---

## Users and Groups (RBAC)

Adding users to the Organizational Units created.

<img src="./Screenshots/user-creation.png" width="700">


execute the Script 1 in Scripts Folder



### Security Groups Creation and making users members of creating sec-groups.

### Security Groups & Role-Based Access Control (RBAC)

Role-Based Access Control (RBAC) was implemented by assigning permissions to **security groups** instead of individual users, ensuring scalability, consistency, and simplified access management.

| **Group Name**          | **Purpose**                          |
|-------------------------|--------------------------------------|
| **HR_Read**             | Read-only access to HR data           |
| **Finance_Modify**      | Modify access to Finance data         |
| **IT_Admin**            | Administrative privileges            |
| **Workstation_Users**   | Standard domain workstation users    |


Execute group.ps1 in Scripts 




<img src="./Screenshots/sec-group creation and users.png" width="700">

- `Finance_Modify`
- `HR_Read`
- `IT_Admin`
- `Workstation_Users`

## File Server Configuration

A centralized file server (**FS01**) was configured and joined to the domain.

<img src="./Screenshots/file-shares.png" width="700">


### Shared Folders

| Share | Path | Access |
|----|----|----|
| Finance | `C:\Shares\Finance` | Finance_Modify – Modify |
| HR | `C:\Shares\HR` | HR_Read – Read |

<img src="./Screenshots/NTFS.png" width="700">
<img src="./Screenshots/SHARE.png" width="700">


Share permissions were used to control network-level access, while NTFS permissions enforced granular file system security. Effective access was determined by the most restrictive combination of both permission sets, following Microsoft best practices.


- NTFS permissions enforced least-privilege access  
- Default permissions were removed  
- Access controlled strictly through security groups

  <img src="./Screenshots/FINANCE-ACC-DENIED.png" width="700">

  Members of Finance_Modify Security group were denied access to HR Shared Folder





---

## Group Policy Implementation

### Domain Security Policies

- Applied at the domain level

<img src="./Screenshots/DOMAIN-PASSWORD-GPO.png" width="700">

- Password complexity enforced

<img src="./Screenshots/PASSWORD-POLICY.png" width="700">


- Account lockout configured

<img src="./Screenshots/ACCOUNT-LOCKOUT.png" width="700">









### User Restrictions Policy

A dedicated Group Policy Object (GPO) was created to enforce user-level restrictions and linked to the `CorpUsers` Organizational Unit. This ensures restrictions follow users regardless of the workstation they log into.

#### Policy Scope
- **Applied to:** `OU=CorpUsers`
- **Policy Type:** User Configuration

#### Configured Settings
- Prohibit access to Control Panel and Windows Settings

<img src="./Screenshots/USER-POLICY-CONTROL.png" width="700">
<img src="./Screenshots/CONTROL--PANEL.png" width="700">

#### Policy Enforcement Result

When a standard domain user attempts to access the Control Panel or Windows Settings, access is denied as expected.

<img src="./Screenshots/CONTROL-PANEL-DENIED.png" width="700">


## Drive Mapping via GPO

Network drives were automated using **Group Policy Preferences**.


- Applied at user logon  
- Item-level targeting based on `Finance_Modify` security group  

<img src="./screenshots/drive-mapping.png" width="700">

---

## USB Security Enforcement

USB storage devices were blocked using a **Computer Configuration Group Policy**.


- Applied to `OU=Workstations`
- Validated using VMware USB passthrough  

<img src="./screenshots/usb-blocked.png" width="700">

---

## Printer Deployment

A centralized print server was deployed on **FS01**.

- Print and Document Services installed
- Virtual printer created and shared
- Deployed via Group Policy Preferences
- Targeted using `Finance_Modify`

<img src="./screenshots/printer-deployed.png" width="700">

---

## Validation and Testing

Validation was performed using:

```bash
gpupdate /force
gpresult /r
whoami /groups
