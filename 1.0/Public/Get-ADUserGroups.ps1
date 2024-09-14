Function Get-ADUserGroups {

    <#
    .SYNOPSIS
        Retrieves and compares the group memberships of two Active Directory (AD) users.
    
    .DESCRIPTION
        This function gets the group memberships for two specified AD users and provides a comparison of their memberships.
        It outputs the groups each user belongs to in a simplified format for easier comparison.
    
    .PARAMETER user1
        The SamAccountName or distinguished name (DN) of the first AD user to compare.
    
    .PARAMETER user2
        The SamAccountName or distinguished name (DN) of the second AD user to compare.
    
    .EXAMPLE
        Get-ADUserGroups -user1 "user1" -user2 "user2"
        This example retrieves and compares the group memberships of `user1` and `user2`.
        The output will show which groups each user belongs to.
    
    .NOTES
        - The output includes the group memberships of both users in a simplified format.
        - This function is useful for determining which groups a user needs to be added to or removed from based on another user's memberships.
    
    #>

    [CmdletBinding()]
    Param (
        [string]$user1,
        [string]$user2
    )

    # Get the group memberships of both users
    $user1Info = Get-ADUser -Identity $user1 -Property MemberOf, SamAccountName
    $user2Info = Get-ADUser -Identity $user2 -Property MemberOf, SamAccountName

    # Retrieve group memberships
    $user1Groups = $user1Info.MemberOf
    $user2Groups = $user2Info.MemberOf

    # Convert DistinguishedNames to simple Group Names for easier comparison
    $user1GroupNames = $user1Groups | ForEach-Object { ($_ -split ',')[0] -replace '^CN=' }
    $user2GroupNames = $user2Groups | ForEach-Object { ($_ -split ',')[0] -replace '^CN=' }

    # Verbose logging for user groups
    Write-Verbose "$($user1Info.SamAccountName) is part of the following groups: $($user1GroupNames -join ', ')"
    Write-Verbose "$($user2Info.SamAccountName) is part of the following groups: $($user2GroupNames -join ', ')"

    # Output the necessary values
    $comparisonResult = [PSCustomObject]@{
        User1 = $user1
        User1GroupNames = $user1GroupNames
        User2 = $user2
        User2GroupNames = $user2GroupNames
    }
    $comparisonResult
}