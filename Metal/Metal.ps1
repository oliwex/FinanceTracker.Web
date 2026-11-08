Add-PodeWebPage -Name "Gold" -Icon "mdi-gold" -Group "Fortune" -ScriptBlock {
    New-PodeWebCard -Content @(

        New-PodeWebTable -Name "GoldTable" -ScriptBlock {
            
            $totalVolume = 0
            $totalAmount = 0
            $table = Get-MetalFromFile -FilePath "$PSSCriptRoot\metal.txt" | ForEach-Object {

                $totalVolume += $_.VOLUME
                $totalAmount += $_.PRICE * $_.VOLUME
            
                [PSCustomObject]@{
                    METAL  = $_.METAL
                    BUYER  = if ($_.BUYER -like "*Me*")
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

        New-PodeWebButton -Name 'Dodaj sztabkę' -ScriptBlock {
            Show-PodeWebModal -Name 'AddGoldModal'
        }
        
        New-PodeWebModal -Name 'AddGoldModal' -Content @(
            New-PodeWebForm -Name 'AddGoldForm' -SubmitText 'Zapisz' -Content @(
                #IDEA:Domyślnie zakładamy, że jest to złoto
                New-PodeWebTextbox -Name "Buyer" -DisplayName 'Kupujący' -Type Text -HelpText 'Me albo Mama'
                New-PodeWebDateTime -Name "Date" -DisplayName 'Data zakupu' -Type Date -HelpText "Czas zakupu sztabki"
                New-PodeWebTextbox -Name "Volume" -DisplayName 'Ilość' -Type Number -HelpText "Ilość zakupionych sztabek"
                New-PodeWebTextbox -Name "Price" -DisplayName 'Cena' -Type Number -HelpText "Cena sztabek"

            ) -ScriptBlock {
        
                $json = $WebEvent.Data["Date_Date"] | ConvertTo-Json

                Show-PodeWebToast -Message $json
            
                $line = @(
                    $WebEvent.Data["Buyer"]
                    $WebEvent.Data["Date_Date"]
                    $WebEvent.Data["Volume"]
                    $WebEvent.Data["Price"]
                ) -join ':'
            
                Add-Content -Path "E:\GIT\FinanceTracker.Web\Metal\metal.txt" -Value $line
            
                Sync-PodeWebTable -Name "GoldTable"
            }
        )
#Problemy:Data się nie zapisuje, Dane zapisują się tam, gdzie ostatnio stał kursor w pliku metal
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