param(
    [Parameter(Mandatory = $true)]
    [string] $InputPath
)

if (Test-Path $InputPath -PathType Leaf) {
    # Es un archivo único
    Write-Host "Importando archivo $InputPath usando Docker..."
    
    # Copiar archivo al contenedor
    $filename = Split-Path $InputPath -Leaf
    docker cp "$InputPath" "n8n:/tmp/$filename"
    
    # Importar desde el contenedor
    docker-compose exec n8n n8n import:workflow --input "/tmp/$filename" --force
    
    # Limpiar archivo temporal
    docker-compose exec n8n rm -f "/tmp/$filename"
    
    Write-Host "Importación completada: $filename"
}
elseif (Test-Path $InputPath -PathType Container) {
    # Es una carpeta, importar todos los JSON
    Write-Host "Importando todos los archivos JSON de $InputPath usando Docker..."
    
    Get-ChildItem -Path $InputPath -Filter *.json | ForEach-Object {
        Write-Host "Importando $($_.Name)..."
        
        # Copiar archivo al contenedor
        docker cp "$($_.FullName)" "n8n:/tmp/$($_.Name)"
        
        # Importar desde el contenedor
        docker-compose exec n8n n8n import:workflow --input "/tmp/$($_.Name)" --force
        
        # Limpiar archivo temporal
        docker-compose exec n8n rm -f "/tmp/$($_.Name)"
    }
    
    Write-Host "Importación de carpeta completada"
}
else {
    Write-Error "Ruta no válida: $InputPath"
    exit 1
}
