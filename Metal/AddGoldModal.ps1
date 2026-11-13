New-PodeWebModal -Name 'AddGoldModal' -Content @(
    New-PodeWebForm -Name 'AddGoldForm' -SubmitText 'Save' -Content @(
        #IDEA:Domyślnie zakładamy, że jest to złoto
        New-PodeWebSelect -Name "Buyer" -DisplayName "Buyer" -Options @("Ja", "Mama")
        New-PodeWebDateTime -Name "Date" -DisplayName 'Buy Date' -Type Date -HelpText "Czas zakupu sztabki"
        New-PodeWebTextbox -Name "Volume" -DisplayName 'Volume' -Type Number -HelpText "Ilość zakupionych sztabek"
        New-PodeWebTextbox -Name "Price" -DisplayName 'Price' -Type Number -HelpText "Cena sztabek"

    ) -ScriptBlock {
                
        $query = "INSERT INTO GOLD (METAL, BUYER, DATE, VOLUME, PRICE) VALUES ('GOLD','$($WebEvent.Data["Buyer"])','$($WebEvent.Data["Date_Date"])','$($WebEvent.Data["Volume"])','$($WebEvent.Data["Price"])')"

        Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query $query
                    
        Show-PodeWebToast -Message "`nBuyer: $($WebEvent.Data["Buyer"]) `nDate: $(([datetime]$WebEvent.Data["Date_Date"]).ToString("dd.MM.yyyy")) `nVolume: $($WebEvent.Data["Volume"]) `nPrice: $($WebEvent.Data["Price"])"

        Sync-PodeWebTable -Name "GoldTable"
        Sync-PodeWebTable -Name "MamaJaGold"
        Sync-PodeWebChart -Name "MamaJaSumBarsChart"
        Sync-PodeWebChart -Name "MamaJaAllBarsChart"
    }
)