Import-Module Pode.Web

#region Pages

#endregion Pages

Start-PodeServer {
    
    Add-PodeEndpoint -Address localhost -Port 5000 -Protocol Http -Name Index
    
    Use-PodeWebTemplates -Title 'Finance Tracker' -Theme Terminal

    Add-PodeWebPage -Name "Main" -ScriptBlock {
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

    Add-PodeWebPage -Name "Cash" -Icon "mdi-cash" -Group "Fortune"  -ScriptBlock {
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


    Add-PodeWebPage -Name "Gold" -Icon "mdi-gold" -Group "Fortune" -ScriptBlock {
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