Add-PodeWebPage -Name "Gold" -Icon "mdi-gold" -Group "Fortune" -ScriptBlock {
    New-PodeWebCard -Icon "gold" -DisplayName "Gold" -Content @(

        New-PodeWebTable -Name "GoldTable" -DisplayName "Gold Table" -ScriptBlock {

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
                        Show-PodeWebToast -Message "Deleted!"
                        Sync-PodeWebTable -Name "GoldTable"
                        Sync-PodeWebTable -Name "MamaJaGold"

                        Sync-PodeWebChart -Name "MamaJaSumBarsChart"
                        Sync-PodeWebChart -Name "MamaJaAllBarsChart"
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
    
        New-PodeWebAccordion -Bellows @(
        New-PodeWebBellow -Name Bellow1 -DisplayName "GOLD Comparison" -Content @(
                New-PodeWebTable -Name "MamaJaGold" -ScriptBlock {
                    Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "SELECT BUYER,SUM(VOLUME),MIN(PRICE),MAX(PRICE),SUM(PRICE*VOLUME) FROM GOLD GROUP BY BUYER" | ForEach-Object {
                        [PSCustomObject]@{
                            BUYER = if ($_.BUYER -like "*Ja*")
                            {
                                New-PodeWebIcon -Name "face-man" -Colour "#00FF00"
                            }
                            else
                            {
                                New-PodeWebIcon -Name "face-woman" -Colour "#FF0000"
                            }
                            SUM_BAR = $($_."SUM(VOLUME)")
                            MIN_PRICE = "$($_."MIN(PRICE)") PLN"
                            MAX_PRICE = "$($_."MAX(PRICE)") PLN"
                            SUM_PRICE = "$($_."SUM(PRICE*VOLUME)") PLN"
                        }
                    }
                }
                $table=Invoke-SqliteQuery -DataSource "$PSScriptRoot\..\DB\fortune.db" -Query "SELECT BUYER,SUM(VOLUME),MIN(PRICE),MAX(PRICE),SUM(PRICE*VOLUME) FROM GOLD GROUP BY BUYER" -As PSObject
        
                New-PodeWebChart -Name "MamaJaSumBarsChart" -Type bar -ArgumentList (,$table) -Height "300px" -ScriptBlock {
                    param($table)
                    $table | Select-Object BUYER,@{Name="BARS";Expression={$_."SUM(VOLUME)"}} | ConvertTo-PodeWebChartData -LabelProperty BUYER -DatasetProperty BARS
                }
        
                New-PodeWebChart -Name "MamaJaAllBarsChart" -Type bar -ArgumentList (,$table) -Height "300px" -ScriptBlock {
                    param($table)
                    $table | Select-Object BUYER,@{Name="MIN";Expression={$_."MIN(PRICE)"}},@{Name="MAX";Expression={$_."MAX(PRICE)"}},@{Name="SUM";Expression={$_."SUM(PRICE*VOLUME)"}} | ConvertTo-PodeWebChartData -LabelProperty BUYER -DatasetProperty MIN,MAX,SUM
                }
            )
        New-PodeWebBellow -Name Bellow2 -Content @(

            New-PodeWebImage -Source '/pode.web-static/images/icon.png' -Alignment Center
            )
        New-PodeWebBellow -Name Bellow3 -Content @(
            New-PodeWebImage -Source '/pode.web-static/images/icon.png' -Alignment Center
            )
        )

        
        




#TODO: Wyczyszczenie kodu
#TODO: Przy kasowaniu danych zrobić okienko modalne z potwierdzeniem tak lub nie        
#TODO: Dodanie formularza modalnego w którym będzie krok pośredni z potwierdzeniem, że dodajemy daną sztabkę.
#TODO: Przy dodwaniu lub usuwaniu sztabki konieczna jest również synchronizacja wykresów
)
}