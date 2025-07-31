param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = "credentials_$timestamp.json"
$fullPath = Join-Path $OutputFolder $outputFile

Write-Host "Exportando credenciales usando Docker..."

# Exportar credenciales dentro del contenedor
docker-compose exec n8n n8n export:credentials --all --pretty --separate --output "/tmp/$outputFile"

# Copiar archivo del contenedor al host
docker cp "n8n:/tmp/$outputFile" "$fullPath"

# Limpiar archivo temporal del contenedor
docker-compose exec n8n rm -f "/tmp/$outputFile"

Write-Host "Credenciales exportadas a $fullPath"
