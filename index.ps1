Import-Module Pode.Web

. "$PSScriptRoot\Metal\Get-MetalFromFile.ps1"



Start-PodeServer {
    
    Add-PodeEndpoint -Address localhost -Port 5000 -Protocol Http -Name Index
    
    Use-PodeWebTemplates -Title 'Finance Tracker' -Theme Light

    Add-PodeWebPage -Name 'Main' -Icon 'Settings' -ScriptBlock {
        New-PodeWebGrid -Cells @(
            New-PodeWebCell -Content @(
    
                New-PodeWebTable -Name "GoldTable" -DisplayName "Tabela złota" -ScriptBlock {
                    foreach ($line in [System.IO.File]::ReadLines("E:\GIT\FinanceTracker.Web\Metal\metal.txt"))
                    {
                        if ($line -like "*Element:Metal*")
                        {
                            continue
                        }
                        elseif ($line -like "*Gold*")
                        {
                            $groupName = $line
                        }
                        else
                        {
                            [PSCustomObject]@{
                                METAL  = $groupName
                                AMOUNT = $line.Split(":")[0]
                                TYPE   = $line.Split(":")[1]
                            }
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
    }
    
    Use-PodeWebPages -Path "$PSScriptRoot\Metal\Metal.ps1"
    Use-PodeWebPages -Path "$PSScriptRoot\Cash\Cash.ps1"

    
}