#Error Action
$Script:ErrorActionPreference = 'Stop'

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )


#Dot source the files
Foreach($ImportMe in @($Public + $Private)) {
    Try {
        . $ImportMe.FullName
    }Catch{
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

#Export commands
Export-ModuleMember -Function $Public.Basename