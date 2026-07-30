# SecAudit-Toolkit 🛡️

Uma ferramenta automatizada para realizar auditorias rápidas de segurança em ambientes Microsoft Windows e gerar relatórios visuais de vulnerabilidades.

## 📌 Visão Geral do Projeto (Projeto Integrador)

Este repositório contém uma solução prática desenvolvida para a coleta de dados de segurança em sistemas Windows. O objetivo é facilitar a identificação de falhas comuns em configurações de rede, firewall e permissões, traduzindo dados do terminal para um painel gerencial.

## 🚀 Funcionalidades

- **Módulo de Auditoria (`win_audit.ps1`):** 
  - Avaliação de status dos perfis do Windows Defender Firewall (Domain, Private, Public).
  - Varredura e listagem de compartilhamentos de rede abertos (SMB), com filtro inteligente para ignorar compartilhamentos ocultos do sistema.
  - Exportação estruturada de dados em formato JSON.

- **Dashboard Visual (`/dashboard`):** 
  - Interface em HTML/CSS/JS que consome o relatório JSON e exibe alertas de segurança com base no nível de risco (Seguro / Atenção / Vulnerável).

## 🛠️ Como Utilizar

1. Clone este repositório para a sua máquina local.
2. Abra o PowerShell como Administrador.
3. Navegue até o diretório `scripts`.
4. Permita a execução do script temporariamente e execute a ferramenta:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\win_audit.ps1