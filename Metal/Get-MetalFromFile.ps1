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
            [PSCustomObject]@{
                METAL  = $groupName
                AMOUNT = $line.Split(":")[0]
                TYPE   = $line.Split(":")[1]
            }
        }
    }
}
