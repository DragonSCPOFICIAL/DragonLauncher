#!/bin/bash

# Cores para o terminal
RED=\'\\033[0;31m\'
BLUE=\'\\033[0;34m\'
NC=\'\\033[0m\' # No Color

echo -e "${BLUE}=== Desinstalador MultiRoblox Linux (Sober) ===${NC}"

# Diretórios de instalação
INSTALL_DIR="$HOME/.local/share/multiroblox"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

# Confirmar desinstalação
read -p "Tem certeza que deseja desinstalar o MultiRoblox Linux? (s/n): " confirm
if [[ $confirm != "s" && $confirm != "S" ]]; then
    echo "Desinstalação cancelada."
    exit 0
fi

# Remover binários
echo "Removendo comandos..."
rm -f "$BIN_DIR/multiroblox"
rm -f "$BIN_DIR/multiroblox-uninstall"

# Remover arquivo .desktop
echo "Removendo atalho do menu..."
rm -f "$DESKTOP_DIR/multiroblox.desktop"

# Perguntar se deseja remover os perfis (dados do Roblox)
read -p "Deseja remover também todos os perfis e dados do Roblox salvos? (s/n): " remove_data
if [[ $remove_data == "s" || $remove_data == "S" ]]; then
    echo "Removendo diretório de dados e perfis..."
    rm -rf "$INSTALL_DIR"
else
    echo "Mantendo diretório de dados em $INSTALL_DIR"
    # Apenas remove o script principal se não remover tudo
    rm -f "$INSTALL_DIR/multiroblox.py"
    rm -f "$INSTALL_DIR/desinstalar_multiroblox.sh"
fi

echo -e "${RED}MultiRoblox Linux desinstalado com sucesso!${NC}"
