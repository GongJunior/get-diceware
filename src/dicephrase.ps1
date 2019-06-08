<#
.synopsis
Diceware diceroll simulator
.description
Generates a 5 digit number from 11111 to 66666 to match with a diceware list to generate passphrade.  Word conversion list can either be used with numbers manually or matched to list with wordList parameter
.parameter numofwords
Number of words returned
.parameter wordList
Optional: csv word list location.
Expected headers: dicerolls, text
.inputs
None.
.outputs
Writes string to pipeline or console
#>
function Get-Diceware {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
        HelpMessage="Number of word returned")]
        [int16]
        $numofwords,

        [Parameter(HelpMessage="Converts numbers to words from list.  Expects csv headers dicerolls,text")]
        [string]
        $wordList
    )
    
    #diceware random simulator
    #generates a chosen number code groups based on dice roll

    $rng = [Security.cryptography.rngcryptoserviceprovider]::Create()
    $byteholder = New-Object Byte[](1)
    for ($i = 0; $i -lt $numofwords; $i++) {
        for ($j = 0; $j -lt 5; $j++) {
            do {
                $rng.getbytes($byteholder)
            } while ($byteholder[0] -gt 42*6)
            
            
            $dicerollgroup += ($byteholder[0]%6 + 1).ToString()
        }
        $dicerollgroup += ' '
    }
    $rng.dispose()

    #give code to user in number code
    $dicerollgroup | Write-Output

    #find values in csv & return words
    #open csv
    if (!$wordlist -eq $null) {
        $csv = Import-Csv -Path $wordList
        $dicelist = $csv | foreach{
            New-Object psobject -Property @{
                rolls = $_.dicerolls
                words = $_.text
            }
        }
        $convertedrolls=@($dicerollgroup.Split(" ")) | foreach{($dicelist | Where-Object -Property rolls -eq $_).words}

        $convertedrolls | foreach{"$_ "} | Write-Host -NoNewline

        "" | Write-Output
    
    }
        
}
