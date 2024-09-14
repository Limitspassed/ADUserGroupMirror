Import-Module ADUserGroupMirror

# Default values for variables
$DefaultAddOrRemove = "Add"             # Default action to perform (Add or Remove)
$DefaultUser1 = "User1"                 # Default Username 1
$DefaultUser2 = "User2"                 # Default Username 2
$DefaultSmtpServer = "smtp.example.com" # Default SMTP server
$DefaultSmtpPort = 587                  # Default SMTP port
$DefaultFrom = "DoNotReply <default@example.com>" # Default From address
$DefaultTo = "Recipient <recipient@example.com>" # Default To address
$DefaultSubject = ""                    # Default email subject
$DefaultBody = ""                       # Default email body
$DefaultSmtpUsername = "default@example.com" # Default SMTP username
$DefaultSmtpPassword = ""               # Default SMTP password (use app passwords for external servers)

# Prompt user to declare variables and possibly override defaults
$YesOrNo = Read-Host "Do you want to declare variables? (Yes/No)"

if ($YesOrNo -eq "Yes") {
    # Prompt user for each variable, using default values if user input is empty
    $AddOrRemove = Read-Host "Do you select Add or Remove? (Default: $DefaultAddOrRemove)"
    if (-not $AddOrRemove) { $AddOrRemove = $DefaultAddOrRemove }

    $User1 = Read-Host "User 1 Username? (Default: $DefaultUser1)"
    if (-not $User1) { $User1 = $DefaultUser1 }

    $User2 = Read-Host "User 2 Username? (Default: $DefaultUser2)"
    if (-not $User2) { $User2 = $DefaultUser2 }

    $SmtpServer = Read-Host "Enter Mail Server (e.g., smtp.example.com) (Default: $DefaultSmtpServer)"
    if (-not $SmtpServer) { $SmtpServer = $DefaultSmtpServer }

    $SmtpPort = Read-Host "Enter Mail Port (e.g., 587) (Default: $DefaultSmtpPort)"
    if (-not $SmtpPort) { $SmtpPort = $DefaultSmtpPort }

    $From = Read-Host "Enter From address (e.g., User01 <user01@example.com>) (Default: $DefaultFrom)"
    if (-not $From) { $From = $DefaultFrom }

    $To = Read-Host "Enter To addresses (e.g., test1 <test1@example.com>, test2 <test2@example.com>) (Default: $DefaultTo)"
    if (-not $To) { $To = $DefaultTo }

    $Subject = Read-Host "Enter email subject information or leave blank (Default: $DefaultSubject)"
    if (-not $Subject) { $Subject = $DefaultSubject }

    $Body = Read-Host "Enter email body information or leave blank (Default: $DefaultBody)"
    if (-not $Body) { $Body = $DefaultBody }

    $SmtpUsername = Read-Host "Enter email address for SMTP authentication or leave blank if not using (Default: $DefaultSmtpUsername)"
    if (-not $SmtpUsername) { $SmtpUsername = $DefaultSmtpUsername }

    # Prompt for SMTP password securely
    $SmtpPassword = Read-Host "Enter email address password for SMTP authentication or leave blank if not using (Default: $DefaultSmtpPassword)" -AsSecureString
    if (-not $SmtpPassword) { $SmtpPassword = ConvertTo-SecureString $DefaultSmtpPassword -AsPlainText -Force }
} else {
    # Use default values if user does not want to declare variables
    Write-Host "Variables not declared. Using default values."
    $AddOrRemove = $DefaultAddOrRemove
    $User1 = $DefaultUser1
    $User2 = $DefaultUser2
    $SmtpServer = $DefaultSmtpServer
    $SmtpPort = $DefaultSmtpPort
    $From = $DefaultFrom
    $To = $DefaultTo
    $Subject = $DefaultSubject
    $Body = $DefaultBody
    $SmtpUsername = $DefaultSmtpUsername
    $SmtpPassword = ConvertTo-SecureString $DefaultSmtpPassword -AsPlainText -Force
}

# Check and run the appropriate action based on user input
if ($AddOrRemove -eq "Add") {
    # Retrieve AD user groups, add groups from User2 to User1, and send a report
    Get-ADUserGroups -user1 $User1 -user2 $User2 |
        Add-ADUserGroups -Do $YesOrNo -Export $YesOrNo |
        Send-Report -SmtpServer $SmtpServer -SmtpPort $SmtpPort -From $From -To $To -Subject "AD User Group Add" -Body "User 2 groups to add to User1" -SmtpUsername $SmtpUsername -SmtpPassword $SmtpPassword -UseSSL
} elseif ($AddOrRemove -eq "Remove") {
    # Retrieve AD user groups, remove groups from User1 that User2 does not contain, and send a report
    Get-ADUserGroups -user1 $User1 -user2 $User2 |
        Remove-ADUserGroups -Do $YesOrNo -Export $YesOrNo |
        Send-Report -SmtpServer $SmtpServer -SmtpPort $SmtpPort -From $From -To $To -Subject "AD User Group Remove" -Body "User 1 groups to remove that user2 does not contain" -SmtpUsername $SmtpUsername -SmtpPassword $SmtpPassword -UseSSL
} else {
    # Handle invalid input for action
    Write-Host "Please enter either Add or Remove for the AddOrRemove variable."
}