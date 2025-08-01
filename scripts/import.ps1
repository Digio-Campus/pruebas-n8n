param(
    [Parameter(Mandatory = $true)]
    [string] $InputPath,

    [Parameter(Mandatory = $false)]
    [ValidateSet('c', 'credentials', 'w', 'workflows')]
    [string] $Type = 'w' # Default to workflows
)

# Verificar si es credenciales o workflows
if ($Type -eq 'c' -or $Type -eq 'credentials') {
    $Type = 'credentials'
} else {
    $Type = 'workflow'
}

if (Test-Path $InputPath -PathType Leaf) {  # Es un archivo único
    # Crear carpeta temporal
    $TempDir = New-Item -ItemType Directory -Path ([System.IO.Path]::GetTempPath()) -Name "n8n-import-$(Get-Random)"
    Copy-Item -Path $InputPath -Destination $TempDir

    Write-Host "Importando $Type desde archivo $InputPath (usando carpeta temporal)..."
    n8n import:$Type --separate --input $TempDir.FullName --force

    Remove-Item $TempDir.FullName -Recurse -Forc
} elseif (Test-Path $InputPath -PathType Container) { # Es una carpeta, importar todos los JSON
    Write-Host "Importando $Type desde $InputPath..."
    n8n import:$Type --separate --input $InputPath --force
} else {
    Write-Error "Ruta no válida: $InputPath"
    exit 1
}
