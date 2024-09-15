Function Add-ADUserGroups {

    <#
    .SYNOPSIS
        Adds Active Directory (AD) groups to a user based on a comparison with another user's group memberships.
    
    .DESCRIPTION
        This function adds groups from the second user to the first user if the first user is not already a member of those groups.
        It optionally performs the addition of groups and/or exports a report of the changes.
    
    .PARAMETER comparisonResult
        A PSCustomObject containing the comparison result from `Get-ADUserGroups`. It includes:
        - User1: The SamAccountName or distinguished name (DN) of the first user.
        - User1GroupNames: The group names that the first user is currently a member of.
        - User2: The SamAccountName or distinguished name (DN) of the second user.
        - User2GroupNames: The group names that the second user is a member of.
    
    .PARAMETER Do
        Specifies whether to actually perform the addition of groups.
        - "Yes": Performs the addition.
        - "No": Does not perform the addition but will log the intended changes.
    
    .PARAMETER Export
        Specifies whether to export the report of the changes.
        - "Yes": Exports the report to a file.
        - "No": Does not export the report.
    
    .EXAMPLE
        Get-ADUserGroups -user1 "user1" -user2 "user2" | Add-ADUserGroups -Do "Yes" -Export "Yes"
        This example adds groups from `user2` to `user1` if `user1` is not already a member, and exports a report of the added groups.
    
    .EXAMPLE
        Get-ADUserGroups -user1 "user1" -user2 "user2" | Add-ADUserGroups -Do "No" -Export "Yes"
        This example logs the groups that would be added to `user1` from `user2` without actually performing the additions, and exports a report of the changes.
    
    .NOTES
        - Ensure that the `comparisonResult` parameter is passed a valid object from `Get-ADUserGroups`.
        - This function is useful for synchronizing group memberships between users based on another user’s memberships.
    
    #>

    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline = $true)] $comparisonResult,
        [ValidateSet("Yes", "No")][string]$Do = 'No',
        [ValidateSet("Yes", "No")][string]$Export = 'No'
    )

    Process {
        $user1 = $comparisonResult.User1
        $user1GroupNames = $comparisonResult.User1GroupNames
        $user2 = $comparisonResult.User2
        $user2GroupNames = $comparisonResult.User2GroupNames

        $groupsToAdd = $user2GroupNames | Where-Object { $_ -notin $user1GroupNames }

        $report = @()
        if ($groupsToAdd) {
            foreach ($group in $groupsToAdd) {
                if ($Do -eq "Yes") {
                    Add-ADGroupMember -Identity $group -Members $user1
                    $report += "Added $user1 to group $group"
                    Write-Verbose "Added $user1 to group $group"
                } else {
                    $report += "Would add $user1 to group $group"
                    Write-Verbose "Would add $user1 to group $group"
                }
            }
        } else {
            $report += "$user1 already has all the groups that $user2 has."
            Write-Verbose "$user1 already has all the groups that $user2 has."
        }
        if ($Export -eq "Yes") {
            $report
        }
    }
}
