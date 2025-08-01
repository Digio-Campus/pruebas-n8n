# 📁 Scripts N8N - Gestión de Workflows y Credenciales

Esta carpeta contiene scripts de PowerShell para la gestión automatizada de workflows y credenciales en n8n, tanto para instalaciones locales como containerizadas con Docker.

## 🐋 Scripts para Docker vs Local

Los scripts están disponibles en dos variantes:
- **`*_docker.ps1`**: Para instancias de n8n ejecutándose en Docker (usando `docker-compose`)
- **`*.ps1`**: Para instancias de n8n locales (ejecutables directos)

## 📋 Índice de Scripts

### 🔄 Exportación por ID

#### `exportByID.ps1`
**Uso:** Exporta un elemento específico por ID (workflow o credencial)
```powershell
# Exportar workflow por ID
.\exportByID.ps1 -Id "123" -Type w

# Exportar credencial por ID
.\exportByID.ps1 -Id "456" -Type c
```
- **Parámetros:**
  - `Id` (obligatorio): ID del elemento a exportar
  - `Type` (opcional): `w`/`workflow` para workflows, `c`/`credentials` para credenciales (por defecto: `w`)
  - `OutputFolder` (opcional): Carpeta destino (por defecto: directorio actual)
- **Funcionalidad:**
  - Exporta elemento en formato JSON pretty con `--separate`
  - Extrae el nombre del elemento del JSON
  - Sanitiza el nombre y renombra automáticamente

#### `exportById_docker.ps1`
**Uso:** Versión Docker del script anterior
```powershell
.\exportById_docker.ps1 -Id "123" -Type w
```
- **Diferencias:**
  - Utiliza `docker-compose exec n8n` para ejecutar comandos
  - Exporta al contenedor (`/tmp/exports/`) y luego copia al host
  - Limpia archivos temporales del contenedor automáticamente

### 📦 Exportación Masiva

#### `exportAll.ps1`
**Uso:** Exporta TODOS los elementos de un tipo (workflows o credenciales)
```powershell
# Exportar todos los workflows
.\exportAll.ps1 -Type w

# Exportar todas las credenciales
.\exportAll.ps1 -Type c
```
- **Parámetros:**
  - `Type` (opcional): `w`/`workflow` para workflows, `c`/`credentials` para credenciales (por defecto: `w`)
  - `OutputFolder` (opcional): Carpeta destino (por defecto: directorio actual)
- **Funcionalidad:**
  - Exporta todos los elementos usando `--all --separate`
  - Renombra cada archivo automáticamente con nombres legibles
  - Crea carpetas `workflows/` o `credentials/` según el tipo

#### `exportAll_docker.ps1`
**Uso:** Versión Docker para exportación masiva
```powershell
.\exportAll_docker.ps1 -Type w
```
- **Diferencias:**
  - Exporta al contenedor y luego copia al host
  - Gestiona carpetas temporales en el contenedor
  - Limpia automáticamente archivos temporales

### 📥 Importación

#### `import.ps1`
**Uso:** Importa workflows o credenciales desde archivos/carpetas
```powershell
# Importar un workflow específico
.\import.ps1 -InputPath "C:\ruta\al\archivo.json" -Type w

# Importar credenciales desde una carpeta
.\import.ps1 -InputPath "C:\ruta\credenciales\" -Type c
```
- **Parámetros:**
  - `InputPath` (obligatorio): Ruta al archivo o carpeta
  - `Type` (opcional): `w`/`workflow` para workflows, `c`/`credentials` para credenciales (por defecto: `w`)
- **Funcionalidad:**
  - Detecta automáticamente si es archivo único o carpeta
  - Para archivos únicos: crea carpeta temporal para la importación
  - Usa `--separate --force` para sobrescribir elementos existentes

#### `import-docker.ps1`
**Uso:** Versión Docker para importación
```powershell
.\import-docker.ps1 -InputPath "archivo.json" -Type w
```
- **Diferencias:**
  - Copia archivos al contenedor antes de importar
  - Ejecuta importación dentro del contenedor
  - Limpia archivos temporales del contenedor automáticamente

## 🛠️ Configuración

### Variables de Entorno
Los scripts usan por defecto el directorio actual:
```powershell
$OutputFolder = "$PWD" # Directorio actual
```

### Estructura de Carpetas Generadas
- `workflows/` - Workflows exportados
- `credentials/` - Credenciales exportadas

### Para Docker
Asegúrate de que:
- `docker-compose.yml` esté en la carpeta raíz
- El servicio se llame `n8n`
- El contenedor tenga acceso de escritura a `/tmp/`

## 🔧 Características Técnicas

### Sanitización de Nombres
Todos los scripts reemplazan caracteres inválidos en nombres de archivo:
```powershell
$cleanName = $name -replace '[<>:"/\\|?*]', '_'
```

### Gestión de Errores
- Verificación de existencia de archivos
- Validación de JSON
- Limpieza automática de archivos temporales

### Formato JSON
- Todos los exports usan `--pretty` para formato legible
- Uso de `--separate` para archivos individuales -> cada workflow/credencial en su propio archivo para el import estandarizado
- Flag `--force` en imports para sobrescribir

## 🚀 Ejemplos de Uso

### Backup Completo de Workflows
```powershell
# Local
.\exportAll.ps1 -Type w

# Docker
.\exportAll_docker.ps1 -Type w
```

### Backup Completo de Credenciales
```powershell
# Local
.\exportAll.ps1 -Type c

# Docker
.\exportAll_docker.ps1 -Type c
```

### Exportar Elemento Específico
```powershell
# Workflow por ID (Docker)
.\exportById_docker.ps1 -Id "456" -Type w

# Credencial por ID (Local)
.\exportByID.ps1 -Id "789" -Type c
```

### Importación Selectiva
```powershell
# Importar workflow específico
.\import-docker.ps1 -InputPath "workflows\Mi Workflow.json" -Type w

# Importar todas las credenciales
.\import.ps1 -InputPath "credentials\" -Type c
```

### Migración Completa entre Entornos
```powershell
# En entorno origen (exportar todo)
.\exportAll_docker.ps1 -Type w
.\exportAll_docker.ps1 -Type c

# En entorno destino (importar todo)
.\import-docker.ps1 -InputPath "workflows\" -Type w
.\import-docker.ps1 -InputPath "credentials\" -Type c
```

## ⚠️ Notas Importantes

1. **Unificación de Scripts**: Los scripts ahora manejan tanto workflows como credenciales usando el parámetro `-Type`
2. **Directorio por Defecto**: Los scripts usan el directorio actual (`$PWD`) en lugar de una ruta fija
3. **Credenciales**: Las credenciales exportadas no incluyen valores sensibles por seguridad de n8n
4. **Sobrescritura**: Los imports usan `--force` y sobrescriben datos existentes
5. **Dependencias**: Los workflows con dependencias deben importarse en orden correcto
6. **Docker**: Los scripts Docker requieren que el servicio esté ejecutándose
7. **Nombrado de Archivos**: En caso de elementos con el mismo `name`, se sobrescribirá el archivo anterior
8. **Gestión Temporal**: Los scripts Docker limpian automáticamente archivos temporales del contenedor

## 🆕 Mejoras en la Nueva Versión

- ✅ **Unificación**: Un solo script maneja workflows y credenciales
- ✅ **Flexibilidad**: Directorio de salida configurable (por defecto: directorio actual)
- ✅ **Robustez**: Mejor gestión de archivos temporales en Docker
- ✅ **Consistencia**: Nomenclatura clara (`exportAll`, `exportByID`, `import`)
- ✅ **Validación**: Parámetros validados con `ValidateSet`

## 🔄 Versionado y Backup

### Para Mantener Versiones Históricas
```powershell
# Backup con timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
.\exportAll_docker.ps1 -Type w -OutputFolder "backup_$timestamp"
```

### Estructura de Archivos Recomendada
```
proyecto/
├── backups/
│   ├── 20250801_143022/
│   │   ├── workflows/
│   │   └── credentials/
│   └── latest/
│       ├── workflows/
│       └── credentials/
└── scripts/
    ├── exportAll.ps1
    ├── exportAll_docker.ps1
    ├── exportByID.ps1
    ├── exportById_docker.ps1
    ├── import.ps1
    └── import-docker.ps1
```


