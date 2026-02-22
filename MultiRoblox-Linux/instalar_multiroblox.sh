#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Instalador MultiRoblox Linux (Sober) ===${NC}"

# Verificar se o Tkinter está instalado (pacote 'tk' no Arch Linux)
# Verifica se o comando 'pacman' existe (indicando Arch Linux ou derivado)
if command -v pacman &> /dev/null; then
    if ! pacman -Qi tk &> /dev/null; then
        echo -e "${BLUE}Instalando dependência necessária (tk) para Arch Linux...${NC}"
        sudo pacman -S --noconfirm tk
    fi
# Verifica se o comando 'apt' existe (indicando Debian/Ubuntu ou derivado)
elif command -v apt &> /dev/null; then
    if ! dpkg -s python3-tk &> /dev/null; then
        echo -e "${BLUE}Instalando dependência necessária (python3-tk) para Debian/Ubuntu...${NC}"
        sudo apt update
        sudo apt install -y python3-tk
    fi
# Verifica se o comando 'dnf' existe (indicando Fedora ou derivado)
elif command -v dnf &> /dev/null; then
    if ! rpm -q python3-tkinter &> /dev/null; then
        echo -e "${BLUE}Instalando dependência necessária (python3-tkinter) para Fedora...${NC}"
        sudo dnf install -y python3-tkinter
    fi
else
    echo -e "${RED}Gerenciador de pacotes não suportado ou Tkinter não encontrado. Por favor, instale 'tk' ou 'python3-tk' manualmente.${NC}"
    exit 1
fi

# Diretórios de instalação
INSTALL_DIR="$HOME/.local/share/multiroblox"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

# Criar diretórios se não existirem
mkdir -p "$INSTALL_DIR/profiles"
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"

# Copiar o script principal e o desinstalador
cp multiroblox.py "$INSTALL_DIR/multiroblox.py"
cp desinstalar_multiroblox.sh "$INSTALL_DIR/desinstalar_multiroblox.sh"
chmod +x "$INSTALL_DIR/desinstalar_multiroblox.sh"

# Criar o comando executável no binário local
cat <<EOF > "$BIN_DIR/multiroblox"
#!/bin/bash
python3 "$INSTALL_DIR/multiroblox.py" "\$@"
EOF
chmod +x "$BIN_DIR/multiroblox"

# Criar o comando de desinstalação no binário local
cat <<EOF > "$BIN_DIR/multiroblox-uninstall"
#!/bin/bash
bash "$INSTALL_DIR/desinstalar_multiroblox.sh"
EOF
chmod +x "$BIN_DIR/multiroblox-uninstall"

# Criar o arquivo .desktop para aparecer no menu de aplicativos
cat <<EOF > "$DESKTOP_DIR/multiroblox.desktop"
[Desktop Entry]
Name=MultiRoblox Linux
Comment=Gerenciador de múltiplas instâncias do Roblox (via Sober)
Exec=$BIN_DIR/multiroblox
Icon=roblox
Terminal=false
Type=Application
Categories=Game;
Keywords=roblox;multi;instance;sober;
EOF

echo -e "${GREEN}Instalação concluída com sucesso!${NC}"
echo -e "Você pode iniciar o programa de duas formas:"
echo -e "1. Pelo menu de aplicativos (procure por 'MultiRoblox Linux')"
echo -e "2. Digitando '${BLUE}multiroblox${NC}' no seu terminal."
echo -e ""
echo -e "Para desinstalar, digite: '${BLUE}multiroblox-uninstall${NC}'"
echo -e ""
echo -e "Nota: Como você já tem o Sober instalado, basta abrir o programa, criar perfis e clicar em LANÇAR."
