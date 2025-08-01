param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$outputFile = Join-Path $OutputFolder "credentials"

n8n export:credentials --all --pretty --separate --output $outputFile

Write-Host "Credenciales exportadas a $outputFile"
