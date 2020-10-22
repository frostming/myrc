Set-Alias -Name pdm D:\Workspace\pdm\venv\Scripts\pdm.exe
Set-Alias -Name which Get-Command

Import-Module Posh-Git
Import-Module DockerCompletion

Get-ChildItem "$PROFILE\..\Completions\" | ForEach-Object {
    . $_.FullName
}

