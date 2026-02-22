#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Instalador MultiRoblox Linux (Sober) ===${NC}"

# Verificar se o Python e Tkinter estão instalados (comum no Arch)
if ! pacman -Qi python-tk &> /dev/null; then
    echo -e "${BLUE}Instalando dependência necessária (python-tk)...${NC}"
    sudo pacman -S --noconfirm python-tk
fi

# Diretórios de instalação
INSTALL_DIR="$HOME/.local/share/multiroblox"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

# Criar diretórios se não existirem
mkdir -p "$INSTALL_DIR/profiles"
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"

# Copiar o script principal
cp multiroblox.py "$INSTALL_DIR/multiroblox.py"

# Criar o comando executável no binário local
cat <<EOF > "$BIN_DIR/multiroblox"
#!/bin/bash
python3 "$INSTALL_DIR/multiroblox.py" "\$@"
EOF
chmod +x "$BIN_DIR/multiroblox"

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
echo -e "Nota: Como você já tem o Sober instalado, basta abrir o programa, criar perfis e clicar em LANÇAR."
