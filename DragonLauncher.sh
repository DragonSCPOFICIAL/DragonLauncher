#!/bin/bash

# DragonLauncher - Script de Compatibilidade
# Mantenedor: DragonSCPOFICIAL

# --- Configurações de Caminho ---
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX_DIR="$BASE_DIR/prefixo_isolado"
BIN_X32="$BASE_DIR/bin/x32"
BIN_X64="$BASE_DIR/bin/x64"

# Fallback para o prefixo caso /opt não seja gravável (comum em instalações de sistema)
if [ ! -w "$PREFIX_DIR" ] && [[ "$BASE_DIR" == /opt/* ]]; then
    PREFIX_DIR="$HOME/.local/share/dragonlauncher/prefixo"
    mkdir -p "$PREFIX_DIR"
fi

# --- Verificações de Dependências ---
check_dep() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: '$1' não encontrado. Por favor, instale o pacote necessário."
        [ -n "$DISPLAY" ] && zenity --error --text="Dependência ausente: $1\nPor favor, instale-a para continuar."
        exit 1
    fi
}

check_dep "zenity"
check_dep "wine"
check_dep "file"

# --- Interface Gráfica ---

# 1. Selecionar o Jogo (.exe)
GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe")

if [ -z "$GAME_PATH" ] || [ ! -f "$GAME_PATH" ]; then
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

# --- Configuração do Ambiente ---
export WINEPREFIX="$PREFIX_DIR"
export WINEDEBUG=-all

# Identificar arquitetura do executável
IS_64BIT=$(file "$GAME_PATH" | grep -q "x86-64" && echo "true" || echo "false")

case "$CHOICE" in
    "Mesa3D + DXVK")
        # Overrides para usar as DLLs do Mesa/DXVK fornecidas
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d10core,d3d11,dxgi,opengl32=n,b"
        # Injetar bibliotecas no caminho de busca do sistema
        if [ "$IS_64BIT" = "true" ]; then
            export LD_LIBRARY_PATH="$BIN_X64:$LD_LIBRARY_PATH"
        else
            export LD_LIBRARY_PATH="$BIN_X32:$LD_LIBRARY_PATH"
        fi
        # Carregar config específica se existir
        [ -f "$BASE_DIR/configs/dragon.conf" ] && export DXVK_CONFIG_FILE="$BASE_DIR/configs/dragon.conf"
        ;;
    "dgVoodoo2")
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        if [ "$IS_64BIT" = "true" ]; then
            export LD_LIBRARY_PATH="$BIN_X64:$LD_LIBRARY_PATH"
        else
            export LD_LIBRARY_PATH="$BIN_X32:$LD_LIBRARY_PATH"
        fi
        ;;
    "Padrão Wine")
        export WINEDLLOVERRIDES=""
        ;;
esac

# --- Execução ---
zenity --info --text="Iniciando jogo com: $CHOICE\n\nArquivo: $(basename "$GAME_PATH")\nPrefixo: $WINEPREFIX" --timeout=3 &

# Executar o jogo
wine "$GAME_PATH"
