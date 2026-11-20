#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'Este instalador deve ser executado no Windows.'
}
Get-Command flutter -ErrorAction Stop | Out-Null

Push-Location -LiteralPath (Split-Path -Parent $PSScriptRoot)
try {
    flutter --no-color build windows --release | Tee-Object -Variable buildOutput
    if ($LASTEXITCODE -ne 0) {
        throw "A compilacao do Servix falhou (codigo $LASTEXITCODE)."
    }

    $builtExe = foreach ($line in $buildOutput) {
        if ($line -match 'Built (.+[\\/]servix\.exe)\s*$') {
            $Matches[1]
        }
    }
    if (-not $builtExe) {
        throw 'O Flutter nao informou o caminho do executavel compilado.'
    }
    $bundle = Split-Path -Parent (Resolve-Path -LiteralPath ($builtExe | Select-Object -Last 1)).Path
    if (-not (Test-Path -LiteralPath (Join-Path $bundle 'flutter_windows.dll') -PathType Leaf) -or
        -not (Test-Path -LiteralPath (Join-Path $bundle 'data\flutter_assets') -PathType Container)) {
        throw 'O pacote Windows esta incompleto.'
    }
}
finally {
    Pop-Location
}

$programsDir = Join-Path $env:LOCALAPPDATA 'Programs'
$installDir = Join-Path $programsDir 'Servix'
$installedExe = Join-Path $installDir 'servix.exe'
if ((Test-Path -LiteralPath $installDir) -and
    -not (Test-Path -LiteralPath $installedExe -PathType Leaf)) {
    throw "O destino ja existe e nao contem uma instalacao do Servix: $installDir"
}

$menuDir = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
if (-not $menuDir) {
    throw 'Nao foi possivel localizar o menu Iniciar do usuario.'
}

$token = [Guid]::NewGuid().ToString('N')
$stage = Join-Path $programsDir ".servix-install-$token"
$stagedBundle = Join-Path $stage 'bundle'
$previousBundle = Join-Path $stage 'previous'
$shortcut = Join-Path $menuDir 'Servix.lnk'
$stagedShortcut = Join-Path $menuDir ".servix-install-$token.lnk"
$previousShortcut = Join-Path $menuDir ".servix-install-$token.bak"

New-Item -ItemType Directory -Path $stage -Force | Out-Null
$publishedBundle = $false
$completed = $false
try {
    Copy-Item -LiteralPath $bundle -Destination $stagedBundle -Recurse
    $shell = New-Object -ComObject WScript.Shell
    $link = $shell.CreateShortcut($stagedShortcut)
    $link.TargetPath = $installedExe
    $link.WorkingDirectory = $installDir
    $link.IconLocation = "$installedExe,0"
    $link.Description = 'Servix - SSH Operations Center'
    $link.Save()

    if (Test-Path -LiteralPath $installDir) {
        [System.IO.Directory]::Move($installDir, $previousBundle)
    }
    [System.IO.Directory]::Move($stagedBundle, $installDir)
    $publishedBundle = $true

    if (Test-Path -LiteralPath $shortcut -PathType Leaf) {
        [System.IO.File]::Replace($stagedShortcut, $shortcut, $previousShortcut)
    } else {
        [System.IO.File]::Move($stagedShortcut, $shortcut)
    }
    $completed = $true
}
catch {
    if ($publishedBundle) {
        [System.IO.Directory]::Move($installDir, $stagedBundle)
    }
    if (Test-Path -LiteralPath $previousBundle) {
        [System.IO.Directory]::Move($previousBundle, $installDir)
    }
    throw
}
finally {
    # Keep the backup available if Windows blocked a rollback.
    if ($completed -or -not (Test-Path -LiteralPath $previousBundle)) {
        Remove-Item -LiteralPath $stage -Recurse -Force
    } else {
        Write-Warning "A versao anterior foi preservada em $previousBundle"
    }
    if (Test-Path -LiteralPath $stagedShortcut) {
        Remove-Item -LiteralPath $stagedShortcut -Force
    }
    if (Test-Path -LiteralPath $previousShortcut) {
        if ($completed) {
            Remove-Item -LiteralPath $previousShortcut -Force
        } elseif (-not (Test-Path -LiteralPath $shortcut)) {
            [System.IO.File]::Move($previousShortcut, $shortcut)
        }
    }
}

Write-Host "Servix instalado. Abra pelo menu Iniciar. Executavel: $installedExe"
