function Get-MetalPrice 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,HelpMessage="Metal symbol to get from API")]
        [ValidateSet("XAU","XAG","XPT","XPD")]
        [Alias("MetalSymbol")]
        [String]$symbol,
        
        [Parameter(Mandatory,HelpMessage="Currency symbol for translating metal price from API")]
        [ValidateSet("PLN","USD","EUR")]
        [Alias("CurrencySymbol")]
        [String]$currency
    )
    
    begin {
        $apiData=[PSCustomObject]@{
            URL = "https://www.goldapi.io/api/$symbol/$currency"
            HEADERS = @{
                "x-access-token" = "goldapi-7e15a177b8759529f98f464b67e7017d-io"
                "Content-Type"   = "application/json"
            }
        }
    }
    process 
    {
        try 
        {
            Invoke-RestMethod -Uri $($apiData.URL) -Headers $($apiData.HEADERS) -Method GET
        }
        catch {
            Write-Host "Error: $($_.Exception.Message)"
        }
    }
    end {}
}