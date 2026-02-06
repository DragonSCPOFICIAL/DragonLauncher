#!/bin/bash

# DragonLauncher - Versão Simplificada e Direta
# Mantenedor: DragonSCPOFICIAL

# Definir local da instalação
BASE_DIR="/opt/dragonlauncher"
cd "$BASE_DIR" || exit 1

# 1. Selecionar o Jogo
GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe *.EXE")

if [ -z "$GAME_PATH" ]; then
    exit 0
fi

# 2. Escolher Tradutor
CHOICE=$(zenity --list --radiolist --title="DragonLauncher - Escolha o Tradutor" \
    --column="Seleção" --column="Opção" --column="Descrição" \
    TRUE "Mesa3D + DXVK" "Melhor performance" \
    FALSE "dgVoodoo2" "Jogos Antigos" \
    FALSE "Padrão Wine" "Sem tradutor")

if [ -z "$CHOICE" ]; then
    exit 0
fi

# 3. Configurar e Rodar
export WINEPREFIX="$HOME/.dragonlauncher_prefix"
mkdir -p "$WINEPREFIX"

# Detectar se é 64 ou 32 bits para usar as DLLs certas
if file "$GAME_PATH" | grep -q "x86-64"; then
    BIN_DIR="$BASE_DIR/bin/x64"
else
    BIN_DIR="$BASE_DIR/bin/x32"
fi

case "$CHOICE" in
    "Mesa3D + DXVK")
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d11,dxgi,opengl32=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        ;;
    "dgVoodoo2")
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        ;;
esac

wine "$GAME_PATH"
