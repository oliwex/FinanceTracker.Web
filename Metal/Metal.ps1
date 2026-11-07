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


    ) -Icon "gold" -DisplayName "Złoto"
}