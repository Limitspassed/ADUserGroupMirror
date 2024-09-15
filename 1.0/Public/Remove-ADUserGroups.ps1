Function Remove-ADUserGroups {

    <#
    .SYNOPSIS
        Removes Active Directory (AD) groups from a user based on a comparison with another user's group memberships.
    
    .DESCRIPTION
        This function removes groups from the first user that they belong to but the second user does not.
        It optionally performs the removal of groups and/or exports a report of the changes.
    
    .PARAMETER comparisonResult
        A PSCustomObject containing the comparison result from `Get-ADUserGroups`. It includes:
        - User1: The SamAccountName or distinguished name (DN) of the first user.
        - User1GroupNames: The group names that the first user is currently a member of.
        - User2: The SamAccountName or distinguished name (DN) of the second user.
        - User2GroupNames: The group names that the second user is a member of.
    
    .PARAMETER Do
        Specifies whether to actually perform the removal of groups.
        - "Yes": Performs the removal.
        - "No": Does not perform the removal but will log the intended changes.
    
    .PARAMETER Export
        Specifies whether to export the report of the changes.
        - "Yes": Exports the report to a file.
        - "No": Does not export the report.
    
    .EXAMPLE
        Get-ADUserGroups -user1 "user1" -user2 "user2" | Remove-ADUserGroups -Do "Yes" -Export "Yes"
        This example removes groups from `user1` that `user2` is not a member of and exports a report of the removed groups.
    
    .EXAMPLE
        Get-ADUserGroups -user1 "user1" -user2 "user2" | Remove-ADUserGroups -Do "No" -Export "Yes"
        This example logs the groups that would be removed from `user1` without actually performing the removals, and exports a report of the changes.
    
    .NOTES
        - Ensure that the `comparisonResult` parameter is passed a valid object from `Get-ADUserGroups`.
        - This function is useful for cleaning up group memberships based on another user's group memberships.
    
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

        $groupsToRemove = $user1GroupNames | Where-Object { $_ -notin $user2GroupNames }

        $report = @()
        if ($groupsToRemove) {
            foreach ($group in $groupsToRemove) {
                if ($Do -eq "Yes") {
                    Remove-ADGroupMember -Identity $group -Members $user1 -Confirm:$false
                    $report += "Removed $user1 from group $group"
                    Write-Verbose "Removed $user1 from group $group"
                } else {
                    $report += "Would remove $user1 from group $group"
                    Write-Verbose "Would remove $user1 from group $group"
                }
            }
        } else {
            $report += "$user1 is not a member of any groups that $user2 isn't."
            Write-Verbose "$user1 already has all the groups that $user2 has."
        }
        if ($Export -eq "Yes") {
            $report
        }
    }
}