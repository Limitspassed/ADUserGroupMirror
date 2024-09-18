param(
    [ValidateSet("Add", "Remove")][string]$Action,
    # User1 and User2 SamAccountNames
    [string]$User1 = "user1",
    [string]$User2 = "user2",
    # SMTP Settings
    [string]$SmtpServer = "smtp.gmail.com",
    [int]$SmtpPort = 587,
    [string]$From = "default <default@default.com>",
    [string]$To = "<default@default.com>",
    [string]$Subject = "default",
    [string]$Body = "default",
    # Secure SMTP Credentials
    [string]$SmtpUsername = "default@default.com",
    [string]$SmtpAppPassword = "",
    #Yes and No Strings
    [string]$Yes = "Yes",
    [string]$No = "No"
)

Import-Module ADUserGroupMirror

Import-Module ADUserGroupMirror

$Action = Read-Host "Add or Remove?"
$VerboseStateInput = Read-Host "Verbose True or False?"

# Convert user input to a Boolean value
[bool]$VerboseState = [System.Convert]::ToBoolean($VerboseStateInput)

if (-not $SmtpAppPassword) {
    $SmtpAppPassword = Read-Host "Enter SMTP password"
}

# Execute based on action (Add or Remove)
if ($Action -eq "Add") {
    Get-ADUserGroups -User1 $User1 -User2 $User2 -Verbose:$VerboseState |
    Add-ADUserGroups -Do $Yes -Export $Yes -Verbose:$VerboseState |
    Send-Report -SmtpServer $SmtpServer -SmtpPort $SmtpPort -From $From -To $To -Subject $Subject -Body $Body -SmtpUsername $SmtpUsername -SmtpPassword $SmtpAppPassword -UseSSL
} elseif ($Action -eq "Remove") {
    Get-ADUserGroups -User1 $User1 -User2 $User2 |
    Remove-ADUserGroups -Do $Yes -Export $Yes -Verbose:$VerboseState |
    Send-Report -SmtpServer $SmtpServer -SmtpPort $SmtpPort -From $From -To $To -Subject $Subject -Body $Body -SmtpUsername $SmtpUsername -SmtpPassword $SmtpAppPassword -UseSSL
} else {
    Write-Host "Invalid action. Please enter 'Add' or 'Remove'."
    exit
}