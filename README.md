# N8N Workflows - Testing & Development

> Repositorio de experimentación y testing para workflows n8n

## 🧪 Descripción

Este repositorio está diseñado como **entorno de pruebas** para:
- **Experimentación con AI Assistant** usando sticky notes contextuales
- **Testing de scripts** de gestión de workflows (PowerShell)
- **Pruebas de control de versiones** con Git + automatización
- **Desarrollo de convenciones** para proyectos n8n colaborativos
- **Pruebas de integración** con nodos personalizados
- **Escalabilidad de workers** usando Docker Compose

## 📁 Estructura del Proyecto

```
├── .github/
│   └── copilot-instructions.md     # Instrucciones para GitHub Copilot
├── .gitignore                      # Ignorar archivos en Git
│
├── workflows/                      # Backups de workflows
├── credentials/                    # Backups de credenciales (no versionado)
│
├── scripts/                        # Scripts de PowerShell para gestión
│   ├── README.md                   # Explicación de scripts
│   ├── export*.ps1                 # Scripts de exportación
│   ├── import*.ps1                 # Scripts de importación
│   └── prueba.ps1                  # Script de prueba de workers
│
├── docker-compose.yml              # Configuración de Docker para n8n
├── .dockerignore                   # Ignorar archivos en Docker
│
├── .env.example                    # Plantilla de variables de entorno
├── .env                            # Variables de entorno (no versionado)
│
└── README.md                       # Este archivo, documentación del proyecto
```

## 🤖 Trabajando con AI Assistant (GitHub Copilot)

Para obtener ayuda óptima del AI Assistant:

1. **Añade contexto en tus workflows** usando sticky notes:
   - Nombre: `📋 AI Context`
   - Color: 6 (azul/morado)

2. **Estructura del contexto:**
   ```markdown
   # 🎯 FOCUS
   **What I'm working on:** [descripción del trabajo]
   **Status:** [development/testing/production]

   ## ❓ QUESTIONS FOR AI
   - [pregunta específica 1]
   - [pregunta específica 2]

   ## 🔧 CURRENT ISSUES
   - [problema con detalles]

   ## 📊 FOCUS AREAS
   - [área de enfoque]
   ```

3. **Al compartir workflows:** Menciona "Revisa el AI Context primero"

⚡ **Tip:** Usa GitHub Copilot con las instrucciones incluidas en `.github/copilot-instructions.md` para ayuda contextual automática.

## ⚙️ Configuración del Entorno

### Variables de Entorno
```bash
# 1. Copia el archivo de ejemplo
cp .env.example .env

# 2. Edita el archivo .env con tus credenciales reales
# ⚠️ NUNCA commitees el archivo .env real
```

**Configuraciones principales a personalizar:**
- `N8N_BASIC_AUTH_PASSWORD` - Contraseña de acceso
- `N8N_ENCRYPTION_KEY` - Clave de encriptación (generar nueva)

## Escalado de Workers
Para escalar workers dinámicamente, usa la opción `--scale` de Docker Compose. Esto te permite iniciar múltiples instancias del servicio `n8n-worker`.

```powershell
# Iniciar con 3 workers
docker-compose up -d --scale n8n-worker=3
# Escalar a 5 workers
docker-compose up -d --scale n8n-worker=5

# Ver estado de los workers
docker-compose ps n8n-worker
# Ver logs de todos los workers
docker-compose logs n8n-worker
# Ver estado de las colas en Redis
docker exec -it redis redis-cli LLEN bull:default:active
```

## 🛠️ Scripts Disponibles

Para mas informacion sobre los scripts, revisa el archivo [`scripts/README.md`](scripts/README.md), a continuación se detallan algunos ejemplos:

### Exportar workflows
```powershell
# Exportar workflow específico
.\scripts\exportById.ps1 -WorkflowId "CvOK0QUMpeNo9fcg"

# Exportar todos los workflows
.\scripts\exportAll.ps1
```

### Importar workflows
```powershell
# Importar workflow desde directorio o archivo específico
.\scripts\import.ps1 -FilePath "path/to/workflow.json"
```

### Gestión de credenciales
```powershell
# Backup de credenciales (⚠️ Cuidado con datos sensibles)
.\scripts\exportAll.ps1 -Type "credentials"
```

## 🚀 Nodos Personalizados

Ahora mismo hay un workflow que trabaja con un nodo personalizado, en particular el siguiente:
- [Supabase Upsert](https://github.com/Digio-Campus/n8n-nodes)

