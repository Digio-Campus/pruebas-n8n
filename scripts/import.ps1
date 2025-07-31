param(
    [Parameter(Mandatory = $true)]
    [string] $InputPath
)

if (Test-Path $InputPath -PathType Leaf) {
    # Es un archivo único
    Write-Host "Importando archivo $InputPath..."
    n8n import:workflow --input $InputPath --force
}
elseif (Test-Path $InputPath -PathType Container) {
    # Es una carpeta, importar todos los JSON
    Get-ChildItem -Path $InputPath -Filter *.json | ForEach-Object {
        Write-Host "Importando $($_.FullName)..."
        n8n import:workflow --input $_.FullName --force
    }
}
else {
    Write-Error "Ruta no válida: $InputPath"
    exit 1
}
