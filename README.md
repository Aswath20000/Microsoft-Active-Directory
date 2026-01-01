# Active Directory Infrastructure Lab – Windows Server 2022

An enterprise-style on-premises Active Directory lab built using Windows Server 2022 in VMware Workstation Pro, demonstrating structured OU design, Role-Based Access Control (RBAC), Group Policy enforcement, centralized file and printer services, and validation from domain-joined client systems.

---

## Table of Contents
1. Overview  
2. Architecture  
3. Technologies Used  
4. Active Directory Design  
5. Users and Groups (RBAC)  
6. File Server Configuration  
7. Group Policy Implementation  
8. Drive Mapping via GPO  
9. USB Security Enforcement  
10. Printer Deployment  
11. Validation and Testing  
12. Conclusion  

---

## 1. Overview

This project simulates a real-world enterprise Active Directory environment.  
It focuses on identity management, security policy enforcement, and centralized resource management using Microsoft Windows Server technologies.

The lab demonstrates how system administrators manage users, computers, permissions, and security policies in a controlled on-prem environment.

---

## 2. Architecture

**Domain Name:** `corp.local`

### Virtual Machines

| VM Name | Role |
|------|------|
| DC01 | Domain Controller, DNS, Group Policy |
| FS01 | File Server, Print Server |
| CLIENT01 | Domain-joined workstation |

📸 *Architecture diagram:*  
![Architecture](docs/architecture-diagram.png)

---

## 3. Technologies Used

- Windows Server 2022  
- Windows 11 Client  
- VMware Workstation Pro  
- Active Directory Domain Services (AD DS)  
- DNS  
- Group Policy Management  
- PowerShell  
- NTFS & SMB  
- Print and Document Services  

---

## 4. Active Directory Design

### Organizational Unit (OU) Structure

