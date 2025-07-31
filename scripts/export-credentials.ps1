param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = Join-Path $OutputFolder "credentials_$timestamp.json"

n8n export:credentials --all --pretty --separate --output $outputFile

Write-Host "Credenciales exportadas a $outputFile"
