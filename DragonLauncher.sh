#!/bin/bash

# --- Configurações de Caminho ---
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX_DIR="$BASE_DIR/prefixo_isolado"
BIN_X32="$BASE_DIR/bin/x32"
BIN_X64="$BASE_DIR/bin/x64"

# Criar prefixo se não existir
mkdir -p "$PREFIX_DIR"

# --- Interface Gráfica ---

# 1. Selecionar o Jogo (.exe)
GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe")

if [ -z "$GAME_PATH" ]; then
    exit 0
fi

# 2. Menu de Seleção de Tradutor
CHOICE=$(zenity --list --radiolist --title="DragonLauncher - Escolha o Tradutor" \
    --column="Seleção" --column="Opção" --column="Descrição" \
    TRUE "Mesa3D + DXVK" "Melhor performance (Vulkan/OpenGL moderno)" \
    FALSE "dgVoodoo2" "Melhor compatibilidade para jogos muito antigos (DX 1-8)" \
    FALSE "Padrão Wine" "Sem tradutores customizados (Apenas teste)")

if [ -z "$CHOICE" ]; then
    exit 0
fi

# --- Configuração do Ambiente Baseada na Escolha ---
export WINEPREFIX="$PREFIX_DIR"
export WINEDEBUG=-all

case "$CHOICE" in
    "Mesa3D + DXVK")
        # Força o uso das DLLs que estão na nossa pasta
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d10core,d3d11,dxgi,opengl32=n,b"
        ;;
    "dgVoodoo2")
        # Foco em ddraw e d3dimm para jogos antigos
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        ;;
    "Padrão Wine")
        export WINEDLLOVERRIDES=""
        ;;
esac

# --- Execução ---
zenity --info --text="Iniciando jogo com: $CHOICE\n\nArquivo: $(basename "$GAME_PATH")" --timeout=2

wine "$GAME_PATH"
