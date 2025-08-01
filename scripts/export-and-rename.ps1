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


# 1. Exportar el workflow con "pretty" formateado
Write-Host "Exportando workflow ID $WorkflowId..."
n8n export:workflow --id=$WorkflowId --output="$backupFolder\$WorkflowId.json" --pretty

# 2. Leer e interpretar JSON
$fullpath = "$backupFolder\$WorkflowId.json"
if (!(Test-Path -Path $fullpath)) {
    Write-Error "El archivo exportado no se encontró: $fullpath"
    exit 1
}

$json = Get-Content $fullpath -Raw | ConvertFrom-Json
$wfName = $json[0].name
if (-not $wfName) {
    Write-Error "No se encontró el campo 'name' en el JSON."
    exit 1
}

# Sanitizar nombre de archivo (sin caracteres inválidos)
$wfNameClean = $wfName -replace '[<>:"/\\|?*]', '_'

$newName = "$wfNameClean.json"
$destPath = Join-Path $backupFolder $newName

# 3. Renombrar (si existe, sobrescribir)
if (Test-Path -Path $destPath) {
    Remove-Item -Path $destPath -Force
}

Rename-Item -Path $fullpath -NewName $newName

Write-Host "Workflow renombrado a $newName en $backupFolder"
