# Windows Server 2022 & Active Directory Hardening

## 🌄 Project Overview
This project documents how I set up a secure Windows Server environment in **Microsoft Azure**. My goal was to build an Active Directory that is secure from the start, focusing on organizing permissions correctly and removing unnecessary risks.

**Key Tech:**
* **OS:** Windows Server 2022 Azure Edition
* **Identity:** Active Directory Domain Services (AD DS)
* **Tools:** Group Policy Objects (GPO) & PowerShell
* **Cloud:** Azure Resource Groups & VNet

## 🔒 Security Implementations

### 1. Organizing Access - Identity & Access Management (IAM)
Instead of having a structure where everyone is an admin, I organized the accounts like this:
* **OU Structure:** I separated `Admin_Accounts`, `Service_Accounts`, and `Users` into their own folders.
* **Roles:** I created specific groups (like `GG_Helpdesk`) to avoid using "Domain Admins" accounts for daily tasks.
* **Service Accounts:** I made a restricted account (`svc_backup`) that cannot **log in directly**. It is only allowed to run services in the background.
* **Passwords:** I created a special rule (`PSO_Admins`) that forces administrators to have longer passwords (15 characters) than normal users.

### 2. Group Policy (GPO)
I used GPOs to enforce security rules across the domain:
* **Stopping Brute-Force:** If someone guesses the wrong password 3 times, the account gets locked for 30 minutes.
* **RDP Security:**
    * I enabled **Network Level Authentication (NLA)** for safer connections.
    * I set a timeout so users get logged out if they are away for 15 minutes.
* **Client Safety:**
    * I turned on rules to stop Office apps (like Word) from **starting other programs**, which is a common way viruses spread.
    * I enabled **Controlled Folder Access** to protect against ransomware.

### 3. Better Logging
Standard logs don't show enough info, so I enabled **Advanced Audit Policies**:
* **Logons:** Logs both successful logins and failed attempts (to spot hackers guessing passwords).
* **Privilege Use:** Logs when someone actually **uses** their admin rights.
* **Command Line:** Logs exactly what commands are run in PowerShell, which helps to find **dangerous scripts**.

### 4. Cleaning Up
* **No SMBv1:** I disabled the old SMBv1 protocol because it has known security holes (like WannaCry).
* **Removed Apps:** I uninstalled `XPS-Viewer` since we don't need it and it can be a security risk.

## 📋 Some important notes about the project
This was not everything that was made on the project but it is my part of a group project.

## 📎 Repository Contents
* `hardening_audit.ps1` - Everything was done manually but I tried creating a PowerShell script to configure the security settings and logs automatically, feel free to try in a test VM (DO NOT USE IN PRODUCTION ENV).

---
*Created by [Me](https://github.com/JeNilSE)*
