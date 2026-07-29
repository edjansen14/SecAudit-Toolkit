# SecAudit-Toolkit - Módulo Windows
Write-Host "Iniciando auditoria de segurança no sistema..." -ForegroundColor Cyan

# Define o caminho do arquivo de saída (relativo à raiz do projeto)
$OutputFile = "..\dashboard\report.json"

# Cria um objeto vazio para armazenar os resultados
$AuditResults = @{}

# ---------------------------------------------------------
# CHECAGEM 1: Status do Windows Defender Firewall
# ---------------------------------------------------------
Write-Host "Verificando perfis do Firewall..."
$FirewallProfiles = Get-NetFirewallProfile
$FirewallStatus = @{}

foreach ($Profile in $FirewallProfiles) {
    if ($Profile.Enabled -eq 1) {
        $FirewallStatus[$Profile.Name] = "Seguro"
    } else {
        $FirewallStatus[$Profile.Name] = "Vulneravel"
    }
}
$AuditResults["firewall_status"] = $FirewallStatus


# ---------------------------------------------------------
# CHECAGEM 2: Compartilhamentos de Rede (SMB Shares)
# ---------------------------------------------------------
Write-Host "Analisando compartilhamentos de rede abertos..."
# Filtra compartilhamentos ocultos padrão do sistema (que terminam com $)
$Shares = Get-SmbShare | Where-Object { $_.Name -notmatch "\$$" }

$ShareList = @()
if ($Shares.Count -gt 0) {
    foreach ($Share in $Shares) {
        $ShareList += $Share.Name
    }
    $AuditResults["compartilhamentos_abertos"] = $ShareList
    $AuditResults["risco_compartilhamento"] = "Atencao"
} else {
    $AuditResults["compartilhamentos_abertos"] = "Nenhum"
    $AuditResults["risco_compartilhamento"] = "Seguro"
}


# ---------------------------------------------------------
# EXPORTAÇÃO PARA JSON
# ---------------------------------------------------------
Write-Host "Gerando relatorio JSON..."
# Converte o objeto do PowerShell em uma string JSON formatada
$JsonOutput = $AuditResults | ConvertTo-Json -Depth 3

# Cria a pasta dashboard se ela não existir
$DashboardPath = "..\dashboard"
if (-not (Test-Path $DashboardPath)) {
    New-Item -ItemType Directory -Path $DashboardPath | Out-Null
}

# Salva o arquivo sobrescrevendo o anterior
$JsonOutput | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "Auditoria concluida! Resultados salvos em: $OutputFile" -ForegroundColor Green