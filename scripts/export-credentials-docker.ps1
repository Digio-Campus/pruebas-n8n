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

# Leer todos las credenciales del JSON y renombrarlos individualmente
$credentials = Get-ChildItem -Path $fullPath -Filter "*.json"
foreach ($file in $credentials) {
    $credential = Get-Content $file.FullName -Raw | ConvertFrom-Json
    $nameClean = $credential.name -replace '[<>:"/\\|?*]', '_'
    $filename = "$nameClean.json"
    Move-Item -Path $file.FullName -Destination (Join-Path $fullPath $filename) -Force
}

Write-Host "Credenciales exportadas a $fullPath"
