param(
    [string] $OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
)

$backupFolder = Join-Path $OutputFolder "workflows"
# Crear carpeta de backup

if (!(Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# Exportar todos los workflows por ID 
n8n export:workflow --all --pretty --separate --output $backupFolder

# Leer todos los workflows del JSON y renombrarlos individualmente
$workflows = Get-ChildItem -Path $backupFolder -Filter "*.json"
foreach ($file in $workflows) {
    $wf = Get-Content $file.FullName -Raw | ConvertFrom-Json
    $nameClean = $wf.name -replace '[<>:"/\\|?*]', '_'
    $filename = "$nameClean.json"
    Move-Item -Path $file.FullName -Destination (Join-Path $backupFolder $filename) -Force
}

Write-Host "Backup completo en $backupFolder"
