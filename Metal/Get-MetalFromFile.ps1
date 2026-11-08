function Get-MetalFromFile
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "FilePath to get Metal from File")]
        [Alias("FilePath")]
        [string]$path
    )
    foreach ($line in [System.IO.File]::ReadLines($path))
    {
        if ($line -like "*Element:Metal*")
        {
            continue
        }
        elseif ($line -like "*Gold*")
        {
            $groupName = $line
        }
        else
        {
            $parts=$line.Split(":")
            [PSCustomObject]@{
                METAL  = [String]$($groupName)
                BUYER = [String]$($parts[0])
                DATE   = [datetime]::ParseExact($($parts[1]),"dd.MM.yyyy",$null)
                VOLUME   = [int]$($parts[2])
                PRICE   = [decimal]$($parts[3])
            }
        }
    }
}

Get-MetalFromFile -FilePath "E:\GIT\FinanceTracker.Web\Metal\metal.txt"