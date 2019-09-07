# HostHunterCore0.1
HostHunterCore Public Branch

## Design Goals
1. To create an enterprise grade Cyber hunting framework for Windows, Unix and macos solutions
2. To create a framework which can be used for training
3. To enjoy looking into the amazing world of Cyber Security

## Open Source Standards used
1. Mitre Att&ck Framework
2. CybOX Language Defined Objects Specification - https://cybox.mitre.org/language/specifications/CybOX_Language_Defined_Objects_Specification_v1.0.pdf

## Product Roadmap
- Version 0.2 -> Implement a testing framework. Most likely Pester (powershell)
- Version 0.3 -> Implement developer tools for HostHunter
- Version 0.4 -> Implement artifact integration
- Version 0.5 -> Implement System Escalation

## Setup
1. Windows 10 Enterprise
2. Powershell Remoting enabled (run these commands as an administrator)
    1. `Enable-PSRemoting -Force`
    2. `Set-Item WSMan:\localhost\Client\TrustedHosts <trustedhost(s)  value>`
3. Download HostHunter from git repo 
4. Run `startmission.ps1`
