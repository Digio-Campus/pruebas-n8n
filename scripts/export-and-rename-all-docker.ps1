param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

Write-Host "Exportando todos los workflows usando Docker..."
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = Join-Path $OutputFolder "backup_workflows_$timestamp"

# Crear carpeta de backup
if (!(Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# Obtener lista de workflows desde Docker
$workflowsJson = docker-compose exec n8n n8n list:workflow --output=json
$workflows = $workflowsJson | ConvertFrom-Json

if ($workflows.Count -eq 0) {
    Write-Host "No se encontraron workflows para exportar"
    return
}

Write-Host "Encontrados $($workflows.Count) workflows. Exportando..."

foreach ($workflow in $workflows) {
    Write-Host "Exportando: $($workflow.name) (ID: $($workflow.id))"
    
    # Exportar workflow dentro del contenedor
    docker-compose exec n8n n8n export:workflow --id=$($workflow.id) --output="/tmp/workflow_$($workflow.id).json" --pretty
    
    # Copiar del contenedor al host
    docker cp "n8n:/tmp/workflow_$($workflow.id).json" "$backupFolder\workflow_$($workflow.id).json"
    
    # Leer JSON para obtener nombre y renombrar
    $jsonPath = "$backupFolder\workflow_$($workflow.id).json"
    if (Test-Path $jsonPath) {
        $json = Get-Content -Path $jsonPath -Encoding UTF8 | ConvertFrom-Json
        
        # Limpiar nombre para filename
        $cleanName = $workflow.name -replace '[<>:"/\\|?*]', '_'
        $newFilename = "$cleanName.json"
        $newPath = Join-Path $backupFolder $newFilename
        
        # Renombrar
        Move-Item -Path $jsonPath -Destination $newPath -Force
        Write-Host "  → Guardado como: $newFilename"
    }
    
    # Limpiar archivo temporal del contenedor
    docker-compose exec n8n rm -f "/tmp/workflow_$($workflow.id).json"
}

Write-Host ""
Write-Host "Exportación completada. Archivos guardados en: $backupFolder"
