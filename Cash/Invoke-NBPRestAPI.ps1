function Invoke-NBPRestAPI 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,HelpMessage="Currency symbol to get from NBP")]
        [ValidateSet("USD","EUR","GBP","CHF")]
        [Alias("CurrencySymbol")]
        [String]$currency
    )
    begin {}
    process 
    {
        try 
        {
            (Invoke-RestMethod -Uri "https://api.nbp.pl/api/exchangerates/rates/A/$currency" -Method Get).rates.mid
        }
        catch {
            Write-Warning "Brak możliwości dostępu do API NBP"
        }
    }
    end {}
}