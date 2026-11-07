function Get-MoneyFromFile
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,HelpMessage = "FilePath to get computernames")]
        [Alias("FilePath")]
        [string]$path
    )
    foreach($line in [System.IO.File]::ReadLines($path))
    {
        if ($line -like "*Element:Money*")
        {
            continue
        }
        elseif  ($line -like "*Group*")
        {
            $groupName=$line
        }
        else
        {
            [PSCustomObject]@{
                GROUP = $groupName
                AMOUNT = $line.Substring(0,$line.Length-3)
                CURRENCY = $line.Substring($line.Length-3)
            }
        }
    }
}
