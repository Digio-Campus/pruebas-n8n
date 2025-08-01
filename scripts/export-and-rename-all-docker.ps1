param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

Write-Host "Exportando todos los workflows usando Docker..."
$backupFolder = Join-Path $OutputFolder "workflows"

# Crear carpeta de backup
if (!(Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# Obtener lista de workflows desde Docker
$workflowsList = docker-compose exec n8n n8n list:workflow
$workflows = @()

# Parsear la salida pipe-separated (ID|Name)
foreach ($line in $workflowsList) {
    if ($line -and $line.Contains('|')) {
        $parts = $line.Split('|', 2)
        if ($parts.Length -eq 2) {
            $workflows += [PSCustomObject]@{
                id = $parts[0].Trim()
                name = $parts[1].Trim()
            }
        }
    }
}

if ($workflows.Count -eq 0) {
    Write-Host "No se encontraron workflows para exportar"
    return
}

Write-Host "Encontrados $($workflows.Count) workflows. Exportando..."

foreach ($workflow in $workflows) {
    Write-Host "Exportando: $($workflow.name) (ID: $($workflow.id))"

    # Limpiar nombre para filename
    $cleanName = $workflow.name -replace '[<>:"/\\|?*]', '_'
    $newFilename = "$cleanName.json"
    
    # Exportar workflow dentro del contenedor
    docker-compose exec n8n n8n export:workflow --id=$($workflow.id) --output="/tmp/workflow_$($workflow.id).json" --pretty
    
    # Copiar del contenedor al host
    docker cp "n8n:/tmp/workflow_$($workflow.id).json" "$backupFolder\$newFilename"

    # Limpiar archivo temporal del contenedor
    docker-compose exec n8n rm -f "/tmp/workflow_$($workflow.id).json"
}

Write-Host ""
Write-Host "Exportación completada. Archivos guardados en: $backupFolder"
