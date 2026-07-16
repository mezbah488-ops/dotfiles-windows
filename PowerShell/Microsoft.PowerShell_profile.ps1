# # Prompt
# $env:POSH_THEMES_PATH = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes"
# Import-Module posh-git
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\agnoster.omp.json" | Invoke-Expression
#
function Save-Git {
    param(
        [string]$Message = "update"
    )
    git add .
    git commit -m $Message
    git push
}
#
Set-Alias save Save-Git

function prompt {
    $path = $PWD.Path -replace [regex]::Escape($HOME), '~'

    Write-Host $path -NoNewline -ForegroundColor Cyan

    if (git rev-parse --is-inside-work-tree 2>$null) {
        $gitDir = git rev-parse --git-dir 2>$null
        $gitBranch = git branch --show-current 2>$null
        $status = git status --porcelain 2>$null

        Write-Host " (" -NoNewline -ForegroundColor DarkGray
        Write-Host $gitBranch -NoNewline -ForegroundColor Yellow

        if (Test-Path "$gitDir\MERGE_HEAD") {
            Write-Host " |MERGING|" -NoNewline -ForegroundColor Magenta
        }
        elseif ((Test-Path "$gitDir\rebase-merge") -or (Test-Path "$gitDir\rebase-apply")) {
            Write-Host " |REBASING|" -NoNewline -ForegroundColor Magenta
        }

        if ($status) {
            $added = ($status | Where-Object { $_ -match '^A|^\?\?' }).Count
            $modified = ($status | Where-Object { $_ -match '^.M|^M' }).Count
            $deleted = ($status | Where-Object { $_ -match '^.D|^D' }).Count
            $conflicted = ($status | Where-Object { $_ -match '^UU|^AA|^DD' }).Count

            Write-Host " " -NoNewline
            if ($conflicted) { Write-Host "!$conflicted!conflict " -NoNewline -ForegroundColor Red }
            if ($added)    { Write-Host "+$added " -NoNewline -ForegroundColor Green }
            if ($modified) { Write-Host "~$modified " -NoNewline -ForegroundColor Yellow }
            if ($deleted)  { Write-Host "!$deleted " -NoNewline -ForegroundColor Red }
        } else {
            Write-Host " ✓" -NoNewline -ForegroundColor Green
        }

        Write-Host ")" -NoNewline -ForegroundColor DarkGray
    }

    Write-Host ""
    return "> "
}

#
#
# Import-Module z
#
# Import-Module PSReadLine
# # This enables the gray "ghost" text for history suggestions
# Set-PSReadLineOption -PredictionSource History
# # This lets you use Ctrl+F to accept suggestions
# Set-PSReadLineKeyHandler -Key Alt+f -Function ForwardWord
#
# #Set-PSReadLineKeyHandler -Key F2 -Function SwitchPredictionView
