# Prompt
$env:POSH_THEMES_PATH = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes"
Import-Module posh-git
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\agnoster.omp.json" | Invoke-Expression

function Save-Git {
    param(
        [string]$Message = "update"
    )
    git add .
    git commit -m $Message
    git push
}

Set-Alias save Save-Git




#Import-Module z

Import-Module PSReadLine
# This enables the gray "ghost" text for history suggestions
Set-PSReadLineOption -PredictionSource History
# This lets you use Ctrl+F to accept suggestions
Set-PSReadLineKeyHandler -Key Alt+f -Function ForwardWord

Set-PSReadLineKeyHandler -Key F2 -Function SwitchPredictionView
