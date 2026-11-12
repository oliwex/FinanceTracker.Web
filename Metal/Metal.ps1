Add-PodeWebPage -Name "Gold" -Icon "mdi-gold" -Group "Fortune" -ScriptBlock {
    New-PodeWebCard -Icon "gold" -DisplayName "Gold" -Content @(

        New-PodeWebTable -Name "GoldTable" -ScriptBlock {

            $table=Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "SELECT * FROM GOLD" | ForEach-Object {
                
                $id=$_.ID #IDEA:DO usuwania obiektu

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
                    DELETE = New-PodeWebButton -Name 'Delete ' -DataValue $id -Icon 'delete' -ScriptBlock {

                        Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "DELETE FROM GOLD WHERE ID = $($WebEvent.Data["Value"])"
                        Show-PodeWebToast -Message "Usunięto!"
                        Sync-PodeWebTable -Name "GoldTable"
                    }
                }
            }

            $table += [PSCustomObject]@{
                METAL  = 'RAZEM'
                BUYER  = ''
                DATE   = ''
                VOLUME = $(Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "SELECT SUM(VOLUME) AS SUM_VOLUME FROM GOLD" -As SingleValue)
                PRICE  = ''
                SUM   = "$(Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "SELECT SUM(PRICE*VOLUME) FROM GOLD" -As SingleValue) PLN"
                DELETE = ''
            }
                    
            $table

        } -SimpleFilter -SimpleSort
        
        New-PodeWebButton -Name 'Add' -ScriptBlock {
            Show-PodeWebModal -Name 'AddGoldModal'
        }

        Use-PodeWebPages -Path "$PSScriptRoot\AddGoldModal.ps1" #IDEA:Modal do dodawania sztabek do bazy
    
        
#TODO: Wyczyszczenie kodu
#TODO: Przy kasowaniu danych zrobić okienko modalne z potwierdzeniem tak lub nie        
#TODO: Dodanie formularza modalnego w którym będzie krok pośredni z potwierdzeniem, że dodajemy daną sztabkę.




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
)
}