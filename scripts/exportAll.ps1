param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('c', 'credentials', 'w', 'workflow')]
    [string] $Type = 'w', # Default to workflows

    [Parameter(Mandatory = $false)]
    [string] $OutputFolder = "$PWD" # Default to current directory
)

# Verificar si es credenciales o workflows
if ($Type -eq 'c' -or $Type -eq 'credentials') {
    $Type = 'credentials'
    $backupFolder = Join-Path $OutputFolder "credentials"
    Write-Host "Exportando credenciales en $backupFolder"
} else {
    $Type = 'workflow'
    $backupFolder = Join-Path $OutputFolder "workflows"
}

# Crear carpeta de backup si no existe
if (!(Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# Exportar todos los workflows/credenciales 
n8n export:$Type --all --pretty --separate --output $backupFolder

# Leer todos los workflows/credenciales del JSON y renombrarlos individualmente
$items = Get-ChildItem -Path $backupFolder -Filter "*.json"
foreach ($file in $items) {
    $item = Get-Content $file.FullName -Raw | ConvertFrom-Json
    $nameClean = $item.name -replace '[<>:"/\\|?*]', '_'
    $filename = "$nameClean.json"
    Move-Item -Path $file.FullName -Destination (Join-Path $backupFolder $filename) -Force
}

Write-Host "Backup de $Type completo en $backupFolder"
