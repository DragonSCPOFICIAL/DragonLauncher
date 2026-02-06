#!/bin/bash

# --- Configurações de Caminho ---
# Se instalado via PKGBUILD, BASE_DIR será /opt/dragonlauncher
# Se executado localmente, será a pasta do script
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX_DIR="$BASE_DIR/prefixo_isolado"
BIN_X32="$BASE_DIR/bin/x32"
BIN_X64="$BASE_DIR/bin/x64"

# Verificar se o diretório do prefixo é gravável, se não, usar um local no home do usuário
if [ ! -w "$PREFIX_DIR" ] && [ "$BASE_DIR" = "/opt/dragonlauncher" ]; then
    PREFIX_DIR="$HOME/.local/share/dragonlauncher/prefixo"
fi

mkdir -p "$PREFIX_DIR"

# --- Interface Gráfica ---

# Verificar se zenity está instalado
if ! command -v zenity &> /dev/null; then
    echo "Erro: zenity não está instalado. Por favor, instale o pacote 'zenity'."
    exit 1
fi

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

# Identificar se o executável é 32 ou 64 bits para carregar as DLLs corretas
# Nota: Esta é uma verificação simples, em alguns casos pode precisar de melhorias
IS_64BIT=$(file "$GAME_PATH" | grep -q "x86-64" && echo "true" || echo "false")

case "$CHOICE" in
    "Mesa3D + DXVK")
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d10core,d3d11,dxgi,opengl32=n,b"
        if [ "$IS_64BIT" = "true" ]; then
            export LD_LIBRARY_PATH="$BIN_X64:$LD_LIBRARY_PATH"
        else
            export LD_LIBRARY_PATH="$BIN_X32:$LD_LIBRARY_PATH"
        fi
        ;;
    "dgVoodoo2")
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        # dgVoodoo geralmente requer as DLLs na mesma pasta do jogo ou no sistema
        # Aqui tentamos injetar via LD_LIBRARY_PATH se forem libs mesa customizadas
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
zenity --info --text="Iniciando jogo com: $CHOICE\n\nArquivo: $(basename "$GAME_PATH")\nPrefixo: $WINEPREFIX" --timeout=2

wine "$GAME_PATH"
