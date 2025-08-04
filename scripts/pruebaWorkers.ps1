# Script para probar webhook de n8n con múltiples workers (Compatible con PowerShell 5.1)
# Optimizado para 3 workers con workflow que incluye wait 10s + HTTP request
param(
    [string]$WebhookUrl = "http://localhost:5678/webhook/05dfb243-68a7-4384-9179-37855a1ddba0",
    [int]$RequestCount = 50,  # Más peticiones para probar los 3 workers
    [int]$ThrottleLimit = 15  # 5 peticiones por worker (3 workers * 5 = 15 paralelas)
)

Write-Host "=== PRUEBA DE CARGA PARA N8N WORKERS ===" -ForegroundColor Magenta
Write-Host "Iniciando $RequestCount peticiones al webhook: $WebhookUrl" -ForegroundColor Green
Write-Host "Límite de paralelismo: $ThrottleLimit (optimizado para 3 workers)" -ForegroundColor Yellow
Write-Host "Workflow esperado: Wait 10s + HTTP request (duración ~15s por ejecución)" -ForegroundColor Cyan
Write-Host ""


Write-Host ""
Write-Host "=== COMANDOS ÚTILES PARA MONITOREO ===" -ForegroundColor Magenta
Write-Host "Ver workers activos: docker-compose ps n8n-worker" -ForegroundColor White
Write-Host "Ver logs de workers: docker-compose logs n8n-worker" -ForegroundColor White
Write-Host "Ver cola Redis: docker exec -it redis redis-cli LLEN bull:default:active" -ForegroundColor White
Write-Host ""

# Función para ejecutar una petición
$scriptBlock = {
    param($RequestId, $WebhookUrl)
    
    try {
        $startTime = Get-Date
        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] Ejecutando petición #$RequestId" -ForegroundColor Cyan
        
        # Timeout más largo debido al wait 10s + HTTP request del workflow
        $response = Invoke-RestMethod -Method GET -Uri $WebhookUrl -TimeoutSec 60
        
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        
        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] Petición #$RequestId completada en $([math]::Round($duration, 2))s" -ForegroundColor Green
        
        return @{
            RequestId = $RequestId
            Status = "Success"
            Response = $response
            StartTime = $startTime
            EndTime = $endTime
            Duration = $duration
        }
    }
    catch {
        $endTime = Get-Date
        Write-Warning "[$((Get-Date).ToString('HH:mm:ss'))] Error en petición #$RequestId : $($_.Exception.Message)"
        return @{
            RequestId = $RequestId
            Status = "Failed"
            Error = $_.Exception.Message
            StartTime = $startTime
            EndTime = $endTime
            Duration = 0
        }
    }
}

# Crear y ejecutar jobs en lotes
$allResults = @()
$jobBatches = @()

# Dividir las peticiones en lotes según el ThrottleLimit
for ($i = 1; $i -le $RequestCount; $i += $ThrottleLimit) {
    $batchEnd = [Math]::Min($i + $ThrottleLimit - 1, $RequestCount)
    $batch = $i..$batchEnd
    $jobBatches += ,@($batch)
}

foreach ($batch in $jobBatches) {
    Write-Host "Procesando lote: $($batch -join ', ')" -ForegroundColor Yellow
    
    # Crear jobs para este lote
    $jobs = @()
    foreach ($requestId in $batch) {
        $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $requestId, $WebhookUrl
        $jobs += $job
    }
    
    # Esperar a que terminen todos los jobs del lote
    $jobs | Wait-Job | Out-Null
    
    # Recoger resultados
    foreach ($job in $jobs) {
        $result = Receive-Job -Job $job
        $allResults += $result
        Remove-Job -Job $job
    }
    
    Write-Host "Lote completado" -ForegroundColor Green
    Start-Sleep -Seconds 2  # Pausa breve entre lotes para no saturar
}

# Generar estadísticas 
Write-Host ""
Write-Host "=== ESTADÍSTICAS DE RENDIMIENTO ===" -ForegroundColor Magenta

$successfulRequests = $allResults | Where-Object { $_.Status -eq "Success" }
$failedRequests = $allResults | Where-Object { $_.Status -eq "Failed" }

Write-Host "Total de peticiones: $RequestCount" -ForegroundColor White
Write-Host "Exitosas: $($successfulRequests.Count)" -ForegroundColor Green
Write-Host "Fallidas: $($failedRequests.Count)" -ForegroundColor Red
