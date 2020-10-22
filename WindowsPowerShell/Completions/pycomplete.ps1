if ((Test-Path Function:\TabExpansion) -and -not (Test-Path Function:\_pycomplete_41021f7191de41f7_completeBackup)) {
    Rename-Item Function:\TabExpansion _pycomplete_41021f7191de41f7_completeBackup
}

function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()
    $aliases = @("pycomplete") + @(Get-Alias | where { $_.Definition -eq "pycomplete" } | select -Exp Name)
    $aliasPattern = "($($aliases -join '|'))"
    if ($lastBlock -match "^$aliasPattern ") {
        $command = ($lastBlock.Split() | Where-Object { $_ -NotLike "-*" })[1]

        if ($lastWord.StartsWith("-")) {
            # Complete options
            $opts = @("--version", "--help")
            Switch ($command) {



                default {}
            }
            $opts | Where-Object { $_ -Like "$lastWord*" }
        } elseif ($lastWord -eq $command) {
            # Complete commands
            $commands = @()

            $commands | Where-Object { $_ -Like "$lastWord*" }
        }


    }
    elseif (Test-Path Function:\_pycomplete_41021f7191de41f7_completeBackup) {
        # Fall back on existing tab expansion
        _pycomplete_41021f7191de41f7_completeBackup $line $lastWord
    }
}

