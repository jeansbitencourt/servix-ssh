#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'Este desinstalador deve ser executado no Windows.'
}

$programsDir = Join-Path $env:LOCALAPPDATA 'Programs'
$installDir = Join-Path $programsDir 'Servix'
$installedExe = Join-Path $installDir 'servix.exe'
$menuDir = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
if (-not $menuDir) {
    throw 'Nao foi possivel localizar o menu Iniciar do usuario.'
}
$shortcut = Join-Path $menuDir 'Servix.lnk'

if (Test-Path -LiteralPath $installDir) {
    $installedItem = Get-Item -LiteralPath $installDir -Force
    if (-not $installedItem.PSIsContainer -or
        ($installedItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -or
        -not (Test-Path -LiteralPath $installedExe -PathType Leaf)) {
        throw "O destino nao contem uma instalacao do Servix: $installDir"
    }
    Remove-Item -LiteralPath $installDir -Recurse -Force
}

if (Test-Path -LiteralPath $shortcut -PathType Leaf) {
    $shell = New-Object -ComObject WScript.Shell
    $link = $shell.CreateShortcut($shortcut)
    if ($link.TargetPath -eq $installedExe) {
        Remove-Item -LiteralPath $shortcut -Force
    } else {
        Write-Warning "Atalho preservado porque aponta para outro executavel: $shortcut"
    }
}

Write-Host 'Servix desinstalado. Os dados do usuario foram preservados.'
