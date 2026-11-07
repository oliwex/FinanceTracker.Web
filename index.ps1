Import-Module Pode.Web

Start-PodeServer {
    
    #region EXTERNAL
    #FUNCTIONS
    Use-PodeScript -Path "$PSScriptRoot\Metal\Get-MetalFromFile.ps1"
    Use-PodeScript -Path "$PSScriptRoot\Cash\Get-MoneyFromFile.ps1"
    
    #endregion EXTERNAL
    
    Add-PodeEndpoint -Address localhost -Port 5000 -Protocol Http -Name Index
    
    Use-PodeWebTemplates -Title 'Finance Tracker' -Theme Light

    Add-PodeWebPage -Name 'Sprawozdanie finansowe' -ScriptBlock {
        New-PodeWebGrid -Cells @(
            New-PodeWebCell -Content @(
                New-PodeWebTable -Name "GoldTable" -ScriptBlock {
                    Get-MetalFromFile -FilePath "$PSScriptRoot\Metal\metal.txt"
                }
                New-PodeWebText -Value "Tu będzie wykres"
                New-PodeWebButton -Name "Więcej" -Url http://localhost:5000/groups/Fortune/pages/Gold
            )
            New-PodeWebCell -Content @(
                New-PodeWebTable -Name 'MoneyTable' -ScriptBlock {
                    Get-MoneyFromFile -FilePath "$PSScriptRoot\Cash\money.txt"
                }
                New-PodeWebText -Value "Tu będzie wykres"
                New-PodeWebButton -Name "Więcej" -Url http://localhost:5000/groups/Fortune/pages/Cash
            )
        )
    }

    Use-PodeWebPages -Path "$PSScriptRoot\Metal\Metal.ps1"
    Use-PodeWebPages -Path "$PSScriptRoot\Cash\Cash.ps1"
}