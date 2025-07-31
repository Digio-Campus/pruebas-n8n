param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = Join-Path $OutputFolder "backup_workflows_$timestamp"
New-Item -ItemType Directory -Path $backupFolder | Out-Null

# Exportar todos los workflows en un solo archivo temporal
$tempFile = Join-Path $backupFolder "temp_all.json"
n8n export:workflow --all --pretty --output $tempFile

# Leer todos los workflows del JSON y exportarlos individualmente
$workflows = Get-Content $tempFile -Raw | ConvertFrom-Json
foreach ($wf in $workflows) {
    $nameClean = $wf.name -replace '[<>:"/\\|?*]', '_'
    $filename = "$nameClean.json"
    $wf | ConvertTo-Json -Depth 100 | Out-File -Encoding utf8 "$backupFolder\$filename"
}

Remove-Item $tempFile

Write-Host "Backup completo en $backupFolder"
