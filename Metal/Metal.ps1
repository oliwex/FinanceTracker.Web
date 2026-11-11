Add-PodeWebPage -Name "Gold" -Icon "mdi-gold" -Group "Fortune" -ScriptBlock {
    New-PodeWebCard -Content @(

        New-PodeWebTable -Name "GoldTable" -ScriptBlock {

            $totalVolume = 0
            $totalAmount = 0

            $table=Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "SELECT * FROM GOLD" | ForEach-Object {
                
                $totalVolume += $_.VOLUME
                $totalAmount += $_.PRICE * $_.VOLUME

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
                    SUMA   = "$($_.PRICE * $_.VOLUME) PLN"
                }
            }

            $table += [PSCustomObject]@{
                METAL  = 'RAZEM'
                BUYER  = ''
                DATE   = ''
                VOLUME = $totalVolume
                PRICE  = ''
                SUMA   = "$totalAmount PLN"
            }
                    
            $table

        } -SimpleFilter -SimpleSort
        <#
        New-PodeWebButton -Name 'Dodaj sztabkę' -ScriptBlock {
            Show-PodeWebModal -Name 'AddGoldModal'
        }
        
        New-PodeWebModal -Name 'AddGoldModal' -Content @(
            New-PodeWebForm -Name 'AddGoldForm' -SubmitText 'Zapisz' -Content @(
                #IDEA:Domyślnie zakładamy, że jest to złoto
                New-PodeWebSelect -Name "Buyer" -DisplayName "Kupujący" -Options @("Me","Mama")
                New-PodeWebDateTime -Name "Date" -DisplayName 'Data zakupu' -Type Date -HelpText "Czas zakupu sztabki"
                New-PodeWebTextbox -Name "Volume" -DisplayName 'Ilość' -Type Number -HelpText "Ilość zakupionych sztabek"
                New-PodeWebTextbox -Name "Price" -DisplayName 'Cena' -Type Number -HelpText "Cena sztabek"

            ) -ScriptBlock {
            
                $line = @(
                    $WebEvent.Data["Buyer"]
                    ([datetime]$WebEvent.Data["Date_Date"]).ToString("dd.MM.yyyy")
                    $WebEvent.Data["Volume"]
                    $WebEvent.Data["Price"]
                ) -join ':'

                Show-PodeWebToast -Message "Sztabki dodano: `nKupujący: $($WebEvent.Data["Buyer"]) `nData: $(([datetime]$WebEvent.Data["Date_Date"]).ToString("dd.MM.yyyy")) `nLiczba: $($WebEvent.Data["Volume"]) `nCena: $($WebEvent.Data["Price"])"

                Add-Content -Path "$PSSCriptRoot\metal.txt" -Value "`n$line"
            
                Sync-PodeWebTable -Name "GoldTable"
            }
        
        
        )
        #>
        
#TODO: Dodanie formularza modalnego w którym będzie krok pośredni z potwierdzeniem, że dodajemy daną sztabkę.
#TODO: Wyczyszczenie kodu
#TODO: Zastanowić się nad przełączeniem tego na bazę danych


<#
        Sztabki
        -Ile ma mama ile mam ja
        -%sztabek ujęte w jakimś obrazku
        -Ile procentowo brakuje do określonego celu
        Daty
        -Co ile mniej więcej kupuje sztabki
        -Przewidywanie: Jeśli mam x sztabek i kupuje z taką częstotliwością to kiedy  skończę
        Cena
        Średnia cena sztabki

        Dodawanie usuwanie sztabek z tabeli i do pliku

        Wykresy

        Dynamiczne ceny złota pobierane z API
    
    #>
) -Icon "gold" -DisplayName "Złoto"
}