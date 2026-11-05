Import-Module Pode.Web

Start-PodeServer {
    
    Add-PodeEndpoint -Address localhost -Port 5000 -Protocol Http -Name Index
    
    Use-PodeWebTemplates -Title 'Finance Tracker' -Theme Terminal

    Add-PodeWebPage -Name 'Services' -Icon 'Settings' -ScriptBlock {
        New-PodeWebCard -Content @(
            New-PodeWebTable -Name 'Services' -ScriptBlock {
                foreach ($svc in (Get-Service)) {
                    [ordered]@{
                        Name   = $svc.Name
                        Status = "$($svc.Status)"
                    }
                }
            }
        )
    }
}