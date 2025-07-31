param(
    [Parameter(Mandatory = $true)]
    [string] $WorkflowId,

    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

# Crear carpeta si no existe
if (!(Test-Path -Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# 1. Exportar el workflow con "pretty" formateado usando Docker
Write-Host "Exportando workflow ID $WorkflowId usando Docker..."
docker-compose exec n8n n8n export:workflow --id=$WorkflowId --output="/tmp/$WorkflowId.json" --pretty

# 2. Copiar el archivo del contenedor al host
Write-Host "Copiando archivo desde contenedor..."
docker cp n8n:/tmp/$WorkflowId.json "$OutputFolder\$WorkflowId.json"

# 3. Leer e interpretar JSON
$fullpath = "$OutputFolder\$WorkflowId.json"
if (!(Test-Path -Path $fullpath)) {
    Write-Error "El archivo exportado no se encontró: $fullpath"
    exit 1
}

$json = Get-Content -Path $fullpath -Encoding UTF8 | ConvertFrom-Json

# 4. Obtener nombre del workflow (buscar nodo tipo "workflow")
$workflowName = $null
foreach ($node in $json.nodes) {
    if ($node.type -eq "n8n-nodes-base.workflow" -or $node.type -eq "workflow") {
        $workflowName = $node.parameters.name
        break
    }
}

# Si no encontramos nombre por nodo, buscar en metadata
if (!$workflowName -and $json.name) {
    $workflowName = $json.name
}

# Si aún no hay nombre, usar el ID
if (!$workflowName) {
    $workflowName = "workflow_$WorkflowId"
}

# 5. Limpiar nombre para que sea válido como filename
$cleanName = $workflowName -replace '[<>:"/\\|?*]', '_'
$newFilename = "$cleanName.json"
$newPath = Join-Path $OutputFolder $newFilename

# 6. Renombrar archivo
if ($fullpath -ne $newPath) {
    Move-Item -Path $fullpath -Destination $newPath -Force
    Write-Host "Workflow exportado y renombrado a: $newFilename"
} else {
    Write-Host "Workflow exportado como: $newFilename"
}

# 7. Limpiar archivo temporal del contenedor
docker-compose exec n8n rm -f "/tmp/$WorkflowId.json"
