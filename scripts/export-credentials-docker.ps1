param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$OutputSubFolder = "credentials"
$fullPath = Join-Path $OutputFolder $OutputSubFolder

Write-Host "Exportando credenciales usando Docker..."

# Exportar credenciales dentro del contenedor
docker-compose exec n8n n8n export:credentials --all --pretty --separate --output "/tmp/$OutputSubFolder"

# Copiar los archivos del contenedor al host
docker cp "n8n:/tmp/$OutputSubFolder/." "$fullPath"


# Limpiar archivo temporal del contenedor
docker-compose exec n8n rm -rf "/tmp/$OutputSubFolder"

Write-Host "Credenciales exportadas a $fullPath"
