New-PodeWebGrid -Cells @(
    New-PodeWebCell -Content @(
    
        New-PodeWebTable -Name 'Gold1' -ScriptBlock {
            foreach ($svc in (Get-Service | Select-Object Name, Status -First 5 ))
            {
                [ordered]@{
                    Name   = $svc.Name
                    Status = "$($svc.Status)"
                }
            }

        }

        New-PodeWebChart -Name 'Example Chart1' -Type Line -ScriptBlock {
            return (1..10 | ForEach-Object {
                    @{
                        Key    = $_ # x-axis value
                        Values = @(
                            @{
                                Key   = 'Group1'
                                Value = (Get-Random -Maximum 10) # y-axis value
                            }
                        )
                    }
                })
        }
    )
    New-PodeWebCell -Content @(
        New-PodeWebCard -Content @(
            New-PodeWebTable -Name 'Gold' -ScriptBlock {
                foreach ($svc in (Get-Service | Select-Object Name, Status -First 5 ))
                {
                    [ordered]@{
                        Name   = $svc.Name
                        Status = "$($svc.Status)"
                    }
                }
            }
            New-PodeWebChart -Name 'Example Chart' -Type Line -ScriptBlock {
                return (1..10 | ForEach-Object {
                        @{
                            Key    = $_ # x-axis value
                            Values = @(
                                @{
                                    Key   = 'Group1'
                                    Value = (Get-Random -Maximum 10) # y-axis value
                                }
                            )
                        }
                    })
            }
        )
    )
     

)