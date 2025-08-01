param(
    [Parameter(Mandatory = $true)]
    [string] $Id,

    [Parameter(Mandatory = $false)]
    [ValidateSet('c', 'credentials', 'w', 'workflow')]
    [string] $Type = 'w', # Default to workflows

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

# Crear carpeta si no existe
if (!(Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# 1. Exportar el workflow con "pretty" formateado usando Docker
Write-Host "Exportando $Type con ID $Id usando Docker..."
docker-compose exec n8n mkdir -p /tmp/exports
docker-compose exec n8n n8n export:$Type --id=$Id --separate --output="/tmp/exports/" --pretty

# 2. Copiar el archivo del contenedor al host
Write-Host "Copiando archivo desde contenedor..."
docker cp n8n:/tmp/exports/$Id.json "$backupFolder\$Id.json"

# 3. Limpiar archivo temporal del contenedor
docker-compose exec n8n rm -rf "/tmp/exports/"

# 4. Leer e interpretar JSON
$fullpath = "$backupFolder\$Id.json"
$json = Get-Content $fullpath -Raw | ConvertFrom-Json
$nameClean = $json[0].name -replace '[<>:"/\\|?*]', '_'
$newName = "$nameClean.json"
Move-Item -Path $fullpath -Destination (Join-Path $backupFolder $newName) -Force

Write-Host "$Type renombrado a $newName en $backupFolder"