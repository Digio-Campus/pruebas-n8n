# N8N Workflows - Testing & Development

> Repositorio de experimentación y testing para workflows n8n

## 🧪 Descripción

Este repositorio está diseñado como **entorno de pruebas** para:
- **Experimentación con AI Assistant** usando sticky notes contextuales
- **Testing de scripts** de gestión de workflows (PowerShell)
- **Pruebas de control de versiones** con Git + automatización
- **Desarrollo de convenciones** para proyectos n8n colaborativos
- **Pruebas de integración** con nodos personalizados

## 📁 Estructura del Proyecto

```
├── .github/
│   └── copilot-instructions.md    # Instrucciones para GitHub Copilot
├── backup_workflows_*/            # Backups automáticos de workflows
├── scripts/                       # Scripts de PowerShell para gestión
│   ├── export-and-rename.ps1     # Exportar workflows con nombres descriptivos
│   ├── export-and-rename-all.ps1 # Exportar todos los workflows
│   ├── export-credentials.ps1    # Backup de credenciales
│   └── import.ps1                # Importar workflows
└── README.md                     # Este archivo
```

## 🤖 Trabajando con AI Assistant (GitHub Copilot)

Para obtener ayuda óptima del AI Assistant:

1. **Añade contexto en tus workflows** usando sticky notes:
   - Nombre: `📋 AI Context`
   - Posición: Esquina superior izquierda `[-600, -300]`
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

## 🛠️ Scripts Disponibles

### Exportar workflows
```powershell
# Exportar workflow específico
.\scripts\export-and-rename.ps1 -WorkflowId "CvOK0QUMpeNo9fcg"

# Exportar todos los workflows
.\scripts\export-and-rename-all.ps1
```

### Importar workflows
```powershell
# Importar workflow desde directorio o archivo específico
.\scripts\import.ps1 -FilePath "path/to/workflow.json"
```

### Gestión de credenciales
```powershell
# Backup de credenciales (⚠️ Cuidado con datos sensibles)
.\scripts\export-credentials.ps1
```

## 🚀 Nodos Personalizados

Ahora mismo hay un workflow que trabaja con un nodo personalizado, en particular el siguiente:
- [Supabase Upsert](https://github.com/Digio-Campus/n8n-nodes)

## 🤝 Testing & Experimentación

Este repositorio es ideal para:

1. **Probar scripts de automatización** (export, import, backup)
2. **Experimentar con AI Context** en sticky notes
3. **Testing de control de versiones** con Git + n8n
4. **Desarrollar convenciones de trabajo** colaborativo
5. **Aprender mejores prácticas** de documentación de workflows


