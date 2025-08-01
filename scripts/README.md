# 📁 Scripts N8N - Gestión de Workflows y Credenciales

Esta carpeta contiene scripts de PowerShell para la gestión automatizada de workflows y credenciales en n8n, tanto para instalaciones locales como containerizadas con Docker.

## 🐋 Scripts para Docker vs Local

Los scripts están disponibles en dos variantes:
- **`*-docker.ps1`**: Para instancias de n8n ejecutándose en Docker (usando `docker-compose`)
- **`*.ps1`**: Para instancias de n8n locales (ejecutables directos)

## 📋 Índice de Scripts

### 🔄 Exportación de Workflows

#### `export-and-rename.ps1`
**Uso:** Exporta un workflow específico por ID y lo renombra con su nombre legible
```powershell
.\export-and-rename.ps1 -WorkflowId "123"
```
- **Parámetros:**
  - `WorkflowId` (obligatorio): ID del workflow a exportar
  - `OutputFolder` (opcional): Carpeta destino (por defecto: carpeta actual del proyecto)
- **Funcionalidad:**
  - Exporta workflow en formato JSON pretty
  - Extrae el nombre del workflow del JSON
  - Sanitiza el nombre (elimina caracteres inválidos para archivos)
  - Renombra el archivo con el nombre legible

#### `export-and-rename-docker.ps1`
**Uso:** Versión Docker del script anterior
```powershell
.\export-and-rename-docker.ps1 -WorkflowId "123"
```
- **Diferencias:**
  - Utiliza `docker-compose exec n8n` para ejecutar comandos
  - Exporta primero al contenedor (`/tmp/`) y luego copia al host
  - Limpia archivos temporales del contenedor

#### `export-and-rename-all.ps1`
**Uso:** Exporta TODOS los workflows automáticamente
```powershell
.\export-and-rename-all.ps1
```
- **Funcionalidad:**
  - Exporta todos los workflows usando `--all --separate`
  - Renombra cada archivo con su nombre legible
  - Sobrescribe archivos existentes

#### `export-and-rename-all-docker.ps1`
**Uso:** Versión Docker para exportar todos los workflows
```powershell
.\export-and-rename-all-docker.ps1
```
- **Diferencias:**
  - Obtiene lista de workflows usando `docker-compose exec n8n n8n list:workflow`
  - Parsea la salida pipe-separated (ID|Name)
  - Exporta cada workflow individualmente
  - Gestiona archivos temporales en el contenedor

### 🔐 Exportación de Credenciales

#### `export-credentials.ps1`
**Uso:** Exporta todas las credenciales
```powershell
.\export-credentials.ps1
```
- **Funcionalidad:**
  - Exporta todas las credenciales en archivos separados
  - Renombra archivos con nombres legibles
  - Guarda en carpeta `credentials/`

#### `export-credentials-docker.ps1`
**Uso:** Versión Docker para exportar credenciales
```powershell
.\export-credentials-docker.ps1
```
- **Diferencias:**
  - Exporta al contenedor y luego copia al host
  - Limpia archivos temporales del contenedor

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
  - `Type` (opcional): `w`/`workflows` para workflows, `c`/`credentials` para credenciales
- **Funcionalidad:**
  - Detecta si es archivo único o carpeta
  - Para archivos únicos: crea carpeta temporal para la importación
  - Usa `--separate --force` para sobrescribir

#### `import-docker.ps1`
**Uso:** Versión Docker para importación
```powershell
.\import-docker.ps1 -InputPath "archivo.json" -Type w
```
- **Diferencias:**
  - Copia archivos al contenedor antes de importar
  - Ejecuta importación dentro del contenedor
  - Limpia archivos temporales del contenedor

## 🛠️ Configuración

### Variables de Entorno
Los scripts usan por defecto la siguiente ruta:
```powershell
$OutputFolder = "C:\Users\javil\OneDrive - UNIVERSIDAD DE MURCIA\Trabajo\Digio\n8n"
```

### Estructura de Carpetas
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
- Uso de `--separate` para archivos individuales
- Flag `--force` en imports para sobrescribir

## 🚀 Ejemplos de Uso

### Backup Completo
```powershell
# Exportar todos los workflows
.\export-and-rename-all-docker.ps1

# Exportar todas las credenciales
.\export-credentials-docker.ps1
```

### Migración de Workflow Específico
```powershell
# Exportar
.\export-and-rename-docker.ps1 -WorkflowId "456"

# Importar en otro entorno
.\import-docker.ps1 -InputPath "workflows\Mi Workflow.json" -Type w
```

### Restauración Completa
```powershell
# Importar todos los workflows
.\import-docker.ps1 -InputPath "workflows\" -Type w

# Importar todas las credenciales
.\import-docker.ps1 -InputPath "credentials\" -Type c
```

## ⚠️ Notas Importantes

1. **Credenciales**: Las credenciales exportadas no incluyen valores sensibles por seguridad
2. **Sobrescritura**: Los imports usan `--force` y sobrescriben datos existentes
3. **Dependencias**: Los workflows con dependencias deben importarse en orden
4. **Docker**: Los scripts Docker requieren que el servicio esté ejecutándose
5. **Nombrado de Archivos**: El nombrado de archivos se hace a la fuerza, luego en caso de varios workflows con el mismo `name`, se sobrescribirá el anterior.


