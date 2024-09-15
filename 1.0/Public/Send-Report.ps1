Function Send-Report {

    <#
    .SYNOPSIS
        Sends a report via email and optionally exports it to a file.
    
    .DESCRIPTION
        This function sends a report through email using SMTP settings and optionally exports the report to a specified file path.
        The email can be sent with or without SSL encryption, and supports authentication with a username and password.
    
    .PARAMETER Report
        A collection of strings or text that constitutes the report content to be sent or exported.
    
    .PARAMETER ExportPath
        Optional. The path to the file where the report should be exported. If not specified, the report will only be sent via email.
    
    .PARAMETER SmtpServer
        The SMTP server address to use for sending the email.
    
    .PARAMETER From
        The email address from which the report will be sent.
    
    .PARAMETER To
        The email address to which the report will be sent.
    
    .PARAMETER Subject
        Optional. The subject line of the email. Defaults to "AD User Group Report" if not specified.
    
    .PARAMETER Body
        The body of the email that accompanies the report.
    
    .PARAMETER SmtpUsername
        Optional. The username for SMTP authentication. If not provided, the email will be sent without authentication.
    
    .PARAMETER SmtpPassword
        Optional. The password for SMTP authentication. If `SmtpUsername` is provided, this must also be specified.
    
    .PARAMETER SmtpPort
        Optional. The port number for the SMTP server. Defaults to 25 if not specified.
    
    .PARAMETER UseSSL
        Optional. Indicates whether to use SSL for the SMTP connection. If specified, SSL will be used.
    
    .EXAMPLE
        $reportContent = "This is the report content."
        Send-Report -Report $reportContent -SmtpServer "smtp.gmail.com" -From "example@gmail.com" -To "recipient@example.com" -Subject "Test Report" -Body "Here is the report." -SmtpUsername "username" -SmtpPassword "password" -SmtpPort 587 -UseSSL
        This example sends a report via email using Gmail's SMTP server with SSL encryption.
    
    .EXAMPLE
        $reportContent = "This is the report content."
        Send-Report -Report $reportContent -ExportPath "C:\Reports\report.txt"
        This example exports the report content to a file located at `C:\Reports\report.txt` and does not send it via email.
    
    .NOTES
        - Ensure that the SMTP server settings are correct and that you have permission to send emails through the specified server.
        - If using SSL, make sure that the SMTP server supports SSL on the specified port.
        - The `ExportPath` parameter is optional. If provided, the report will be saved to the specified path before sending the email.
    
    #>

    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline = $true)] $Report,
        [string]$ExportPath,  # Optional: Path to export the report
        [string]$SmtpServer,
        [string]$From,
        [string]$To,
        [string]$Subject = "AD User Group Report",
        [string]$Body,
        [string]$SmtpUsername,
        [string]$SmtpPassword,
        [int]$SmtpPort = 25,
        [switch]$UseSSL
    )
    
    Begin {
        # Initialize an empty string to accumulate the report content
        $fullReport = ""
    }

    Process {
        # Append each report item to $fullReport
        foreach ($item in $Report) {
            $fullReport += $item + "`n"
        }
    }

    End {
        # If ExportPath is provided, export the report to a file
        if ($ExportPath) {
            $fullReport | Out-File -FilePath $ExportPath -Encoding UTF8
            Write-Verbose "Report exported to $ExportPath"
        }

        # If SMTP settings are provided, send the report via email
        if ($SmtpServer -and $From -and $To) {
            $mailParams = @{
                SmtpServer  = $SmtpServer
                Port        = $SmtpPort
                From        = $From
                To          = $To
                Subject     = $Subject
                Body        = "$Body`n$fullReport"
                BodyAsHtml  = $false
            }

            # Add SSL settings if required
            if ($UseSSL) {
                $mailParams.UseSsl = $true
            }

            # If SMTPUsername and SMTPPassword are provided, create a PSCredential object for authentication
            if ($SmtpUsername -and $SmtpPassword) {
                $mailParams.Credential = New-Object System.Management.Automation.PSCredential (
                    $SmtpUsername, (ConvertTo-SecureString $SmtpPassword -AsPlainText -Force)
                )
            }

            # Send the email
            Send-MailMessage @mailParams
            Write-Verbose "Report sent to $To"
        }
    }
}
