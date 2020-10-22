Set-Alias -Name pdm D:\Workspace\pdm\venv\Scripts\pdm.exe
Import-Module Posh-Git
Import-Module DockerCompletion

Get-ChildItem "$PROFILE\..\Completions\" | ForEach-Object {
    . $_.FullName
}

