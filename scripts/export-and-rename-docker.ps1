param(
    [Parameter(Mandatory = $true)]
    [string] $WorkflowId,

    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

# Crear carpeta si no existe
$backupFolder = Join-Path $OutputFolder "workflows"
if (!(Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# 1. Exportar el workflow con "pretty" formateado usando Docker
Write-Host "Exportando workflow ID $WorkflowId usando Docker..."
docker-compose exec n8n n8n export:workflow --id=$WorkflowId --output="/tmp/$WorkflowId.json" --pretty

# 2. Copiar el archivo del contenedor al host
Write-Host "Copiando archivo desde contenedor..."
docker cp n8n:/tmp/$WorkflowId.json "$backupFolder\$WorkflowId.json"

# 3. Leer e interpretar JSON
$fullpath = "$backupFolder\$WorkflowId.json"
if (!(Test-Path -Path $fullpath)) {
    Write-Error "El archivo exportado no se encontró: $fullpath"
    exit 1
}

$json = Get-Content -Path $fullpath -Raw | ConvertFrom-Json
$wfName = $json[0].name
if (-not $wfName) {
    Write-Error "No se encontró el campo 'name' en el JSON."
    exit 1
}
# 4. Limpiar nombre para que sea válido como filename
$cleanName = $wfName -replace '[<>:"/\\|?*]', '_'
$newFilename = "$cleanName.json"
$newPath = Join-Path $backupFolder $newFilename

# 6. Renombrar archivo
Move-Item -Path $fullpath -Destination $newPath -Force
Write-Host "Workflow exportado y renombrado a: $newFilename"

# 7. Limpiar archivo temporal del contenedor
docker-compose exec n8n rm -f "/tmp/$WorkflowId.json"
