document.addEventListener("DOMContentLoaded", () => {
    // Busca o arquivo JSON gerado pelo script
    fetch('report.json')
        .then(response => {
            if (!response.ok) {
                throw new Error("Arquivo report.json não encontrado!");
            }
            return response.json();
        })
        .then(data => {
            preencherDashboard(data);
        })
        .catch(error => {
            console.error("Erro:", error);
            document.getElementById('firewall-card').innerHTML = `<p class="text-red">Erro ao carregar. Você rodou o script no terminal?</p>`;
            document.getElementById('smb-card').innerHTML = `<p class="text-red">Sem dados.</p>`;
        });
});

function preencherDashboard(data) {
    // --- 1. Preencher Firewall ---
    const fwCard = document.getElementById('firewall-card');
    let fwHTML = `<h3>🛡️ Status do Firewall</h3><ul>`;
    let firewallSeguro = true;

    for (const [perfil, status] of Object.entries(data.firewall_status)) {
        let classeCor = status === "Seguro" ? "text-green" : "text-red";
        if(status !== "Seguro") firewallSeguro = false;
        fwHTML += `<li>${perfil}: <span class="${classeCor}">${status}</span></li>`;
    }
    fwHTML += `</ul>`;
    fwCard.innerHTML = fwHTML;
    fwCard.classList.add(firewallSeguro ? "status-seguro" : "status-vulneravel");

    // --- 2. Preencher Compartilhamentos (SMB) ---
    const smbCard = document.getElementById('smb-card');
    const smbRisco = data.risco_compartilhamento;
    let smbHTML = `<h3>📁 Compartilhamentos (SMB)</h3>`;
    
    if (smbRisco === "Seguro") {
        smbHTML += `<p class="text-green">Nenhum compartilhamento aberto detectado.</p>`;
        smbCard.classList.add("status-seguro");
    } else {
        smbHTML += `<p class="text-red">Atenção! Pastas expostas:</p><ul>`;
        data.compartilhamentos_abertos.forEach(pasta => {
            smbHTML += `<li>${pasta}</li>`;
        });
        smbHTML += `</ul>`;
        smbCard.classList.add("status-atencao");
    }
    smbCard.innerHTML = smbHTML;
}