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