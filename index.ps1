#REGION CONFIGURATION
Import-Module Pode.Web
Import-Module PSSQLite

#ENDREGION CONFIGURATION

Start-PodeServer {
    
    #region EXTERNAL
    #FUNCTIONS
    Use-PodeScript -Path "$PSScriptRoot\Cash\Get-MoneyFromFile.ps1"
    
    #endregion EXTERNAL
    
    Add-PodeEndpoint -Address localhost -Port 5000 -Protocol Http -Name Index
    
    Use-PodeWebTemplates -Title 'Finance Tracker' -Theme Light

    Add-PodeWebPage -Name 'Financial Statement' -ScriptBlock {
        New-PodeWebGrid -Cells @(
            New-PodeWebCell -Content @(
                New-PodeWebTable -Name "GoldTable" -ScriptBlock {
                    $dbPath = "$PSScriptRoot\DB\fortune.db"
                    Invoke-SqliteQuery -DataSource $dbPath -Query "SELECT * FROM GOLD" | ForEach-Object {
                        [PSCustomObject]@{
                            METAL  = $_.METAL
                            BUYER  = if ($_.BUYER -like "*Ja*")
                            {
                                New-PodeWebIcon -Name "face-man" -Colour "#00FF00"
                            }
                            else
                            {
                                New-PodeWebIcon -Name "face-woman" -Colour "#FF0000"
                            }
                            DATE   = $_.DATE.ToString('dd.MM.yyyy')
                            VOLUME = $_.VOLUME
                            PRICE  = "$($_.PRICE) PLN"
                            SUM   = "$($_.PRICE * $_.VOLUME) PLN"
                        }
                    }

                }
                New-PodeWebText -Value "Tu będzie wykres"
                New-PodeWebButton -Name "More" -Url http://localhost:5000/groups/Fortune/pages/Gold
            )
            New-PodeWebCell -Content @(
                New-PodeWebTable -Name 'MoneyTable' -ScriptBlock {
                    Get-MoneyFromFile -FilePath "$PSScriptRoot\Cash\money.txt"
                }
                New-PodeWebText -Value "Tu będzie wykres"
                New-PodeWebButton -Name "Więcej" -Url http://localhost:5000/groups/Fortune/pages/Cash
            )
        )

        

        New-PodeWebButton -Name "More" -ScriptBlock { 
            $price=(Invoke-RestMethod -Uri "https://www.goldapi.io/api/XAU/PLN" -Headers @{
                "x-access-token" = "goldapi-7e15a177b8759529f98f464b67e7017d-io"
                "Content-Type"   = "application/json"
            } -Method GET ).PRICE
            Show-PodeWebToast -Message $price
        }


    }


    Use-PodeWebPages -Path "$PSScriptRoot\Metal\Metal.ps1"
    Use-PodeWebPages -Path "$PSScriptRoot\Cash\Cash.ps1"
}