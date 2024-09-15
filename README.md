# AD User Group Mirror Script#

## Overview

The **AD User Group Mirror** script is a PowerShell utility designed for managing Active Directory (AD) user group memberships. It's particularly useful for new hires, department moves, or any situation where you need to mirror group memberships from one user to another. This script supports adding or removing groups and provides email reporting of the actions performed.

## Folder Structure

The repository is structured as follows:

.
├── 1.0/                   
│   ├── Public/ 
│   │   ├── Add-ADUserGroups.ps1        # Script for adding user groups 
│   │   ├── Get-ADUserGroups.ps1        # Script for retrieving user groups 
│   │   ├── Remove-ADUserGroups.ps1     # Script for removing user groups 
│   │   └── Send-Report.ps1             # Script for sending email reports 
│   ├── ADUserGroupMirror.psd1          # Module manifest file 
│   ├── ADUserGroupMirror.psm1          # The main PowerShell module file 
│   └── ExampleScript.ps1               # Example usage script
└── ...

## Module Installation

Move the Module to the PowerShell Modules Folder

To use the module, move the `1.0` folder to one of the PowerShell modules directories. The standard directories are:

- For user-specific installations: `C:\Users\<YourUsername>\Documents\WindowsPowerShell\Modules\`
- For system-wide installations: `C:\Program Files\WindowsPowerShell\Modules\`

For example, you can move it to:

C:\Users<YourUsername>\Documents\WindowsPowerShell\Modules\ADUserGroupMirror\1.0\

## Import the Module

After moving the folder, import the module into your PowerShell session:

Import-Module ADUserGroupMirror -Version 1.0

Verify the Module
Check the available commands and module details:

Get-Command -Module ADUserGroupMirror
Get-Help ADUserGroupMirror

## Module Components

- ADUserGroupMirror.psd1: The module manifest file. It defines the module metadata and dependencies.
- ADUserGroupMirror.psm1: The main module file that combines all the functionalities of the script. It imports the scripts located in the Public folder and provides a unified interface.
- Public/: This folder contains the core scripts for the module:
	- Add-ADUserGroups.ps1: Adds groups from User2 to User1.
	- Get-ADUserGroups.ps1: Retrieves the group memberships for User1 and User2.
	- Remove-ADUserGroups.ps1: Removes groups from User1 that are not present in User2.
	- Send-Report.ps1: Sends an email detailing the changes made.
- ExampleScript.ps1: An example script demonstrating how to use the ADUserGroupMirror module. It shows sample usage and how the individual modules interact.

## How It Works

- Retrieve User Groups: Get-ADUserGroups retrieves the group memberships for User1 and User2.
- Add or Remove Groups: Based on the action specified (Add or Remove), either Add-ADUserGroups or Remove-ADUserGroups is used to modify group memberships.
- Send Email Report: Send-Report sends an email detailing the changes made by the script.

## Usage

Run the Example Script

Open PowerShell and run:
.\ExampleScript.ps1

Follow the prompts to provide necessary input or use default values.

## Custom Usage

For custom usage, run the individual scripts as needed. For example, to add groups:
- Get-ADUserGroups -user1 "User1" -user2 "User2" |
	- Add-ADUserGroups -Do $True -Export $True |
    - Send-Report -SmtpServer "smtp.example.com" -SmtpPort 587 -From "default@example.com" -To "recipient@example.com" -Subject "Group Add Report" -Body "Details of groups added."

## Notes

- SecureString: Use app-specific passwords for external SMTP servers. The script prompts for passwords securely.
- Module Requirements: Ensure necessary AD modules are installed and imported.

## License

This script is licensed under the MIT License. See LICENSE for more information.