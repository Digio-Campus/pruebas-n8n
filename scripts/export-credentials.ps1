param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$outputFile = Join-Path $OutputFolder "credentials"

n8n export:credentials --all --pretty --separate --output $outputFile

# Leer todos las credenciales del JSON y renombrarlos individualmente
$credentials = Get-ChildItem -Path $outputFile -Filter "*.json"
foreach ($file in $credentials) {
    $credential = Get-Content $file.FullName -Raw | ConvertFrom-Json
    $nameClean = $credential.name -replace '[<>:"/\\|?*]', '_'
    $filename = "$nameClean.json"
    Move-Item -Path $file.FullName -Destination (Join-Path $outputFile $filename) -Force
}

Write-Host "Credenciales exportadas a $outputFile"
