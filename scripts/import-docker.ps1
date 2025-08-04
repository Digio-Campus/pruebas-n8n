param(
    [Parameter(Mandatory = $true)]
    [string] $InputPath,

    [Parameter(Mandatory = $false)]
    [ValidateSet('c', 'credentials', 'w', 'workflow')]
    [string] $Type = 'w' # Default to workflows
)

# Verificar si es credenciales o workflows
if ($Type -eq 'c' -or $Type -eq 'credentials') {
    $Type = 'credentials'
} else {
    $Type = 'workflow'
}

if (Test-Path $InputPath -PathType Leaf) {
    # Es un archivo único
    Write-Host "Importando archivo $InputPath usando Docker..."
    
    # Copiar archivo al contenedor
    $filename = Split-Path $InputPath -Leaf
    docker-compose exec n8n mkdir -p /tmp/imports
    docker cp "$InputPath" "n8n:/tmp/imports/$filename"
    
    # Importar desde el contenedor
    docker-compose exec n8n n8n import:$Type --separate --input "/tmp/imports" --force

    # Limpiar archivo temporal
    docker-compose exec n8n rm -rf "/tmp/imports"

    Write-Host "Importación completada: $filename"
}
elseif (Test-Path $InputPath -PathType Container) {
    # Es una carpeta, importar todos los JSON
    Write-Host "Importando $Type desde $InputPath usando Docker..."
    
    # Copiar archivo al contenedor
    docker cp "$InputPath" "n8n:/tmp/"

    # Importar desde el contenedor
    docker-compose exec n8n n8n import:$Type --separate --input "/tmp/$InputPath" --force

    # Limpiar archivo temporal
    docker-compose exec n8n rm -f "/tmp/$InputPath"

}
else {
    Write-Error "Ruta no válida: $InputPath"
    exit 1
}
