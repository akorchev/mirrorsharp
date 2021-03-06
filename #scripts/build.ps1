param (
    $configuration = 'Debug'
)

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'

Write-Output 'dotnet build'
dotnet build --no-restore --configuration $configuration
if ($LastExitCode -ne 0) {
    throw "dotnet build exited with code $LastExitCode"
}

Write-Output 'npm run build'
@('WebAssets', 'Owin.Demo', 'AspNetCore.Demo') | % {
    try {
        Write-Output "  $_"
        Push-Location $_
        npm run build
        if ($LastExitCode -ne 0) {
            throw "npm run build exited with code $LastExitCode"
        }
    }
    finally {
        Pop-Location
    }
}