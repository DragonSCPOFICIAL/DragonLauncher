#!/bin/bash

# DragonLauncher - Script de Compatibilidade
# Mantenedor: DragonSCPOFICIAL

# --- Sistema de Log para Diagnóstico ---
LOG_FILE="$HOME/.dragonlauncher.log"
echo "--- Iniciando DragonLauncher em $(date) ---" > "$LOG_FILE"

# Redirecionar saída para o log e para o terminal (se houver)
exec > >(tee -a "$LOG_FILE") 2>&1

# Verificar se o zenity funciona (necessário para a interface)
if ! command -v zenity &> /dev/null; then
    echo "ERRO: Zenity não instalado. O programa precisa dele para a interface."
    exit 1
fi

# --- Configurações de Caminho ---
# Resolve o caminho real se for um link simbólico
SCRIPT_PATH=$(readlink -f "$0")
BASE_DIR=$(dirname "$SCRIPT_PATH")
echo "Diretório base detectado: $BASE_DIR"

# Definir prefixo de forma segura
if [ -w "/opt/dragonlauncher" ]; then
    PREFIX_DIR="/opt/dragonlauncher/prefixo_isolado"
else
    PREFIX_DIR="$HOME/.local/share/dragonlauncher/prefixo"
    echo "Usando prefixo no Home (sem permissão em /opt): $PREFIX_DIR"
fi
mkdir -p "$PREFIX_DIR"

BIN_X32="$BASE_DIR/bin/x32"
BIN_X64="$BASE_DIR/bin/x64"

# --- Verificações de Dependências ---
check_dep() {
    if ! command -v "$1" &> /dev/null; then
        echo "ERRO: Dependência '$1' não encontrada."
        # Tenta avisar via zenity se disponível, senão apenas loga
        if command -v zenity &> /dev/null; then
            zenity --error --text="Dependência ausente: $1\nPor favor, instale-a usando: sudo pacman -S $1" --title="DragonLauncher - Erro"
        fi
        exit 1
    fi
}

# Verificar dependências essenciais
check_dep "zenity"
check_dep "wine"
check_dep "file"

# --- Interface Gráfica ---

# 1. Selecionar o Jogo (.exe)
echo "Abrindo seletor de arquivos..."
GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe *.EXE")

if [ -z "$GAME_PATH" ]; then
    echo "Nenhum jogo selecionado. Saindo."
    exit 0
fi

if [ ! -f "$GAME_PATH" ]; then
    echo "ERRO: Arquivo não encontrado: $GAME_PATH"
    zenity --error --text="O arquivo selecionado não existe."
    exit 1
fi

echo "Jogo selecionado: $GAME_PATH"

# 2. Menu de Seleção de Tradutor
CHOICE=$(zenity --list --radiolist --title="DragonLauncher - Escolha o Tradutor" \
    --column="Seleção" --column="Opção" --column="Descrição" \
    TRUE "Mesa3D + DXVK" "Melhor performance (Vulkan/OpenGL moderno)" \
    FALSE "dgVoodoo2" "Melhor compatibilidade para jogos antigos (DX 1-8)" \
    FALSE "Padrão Wine" "Sem tradutores customizados (Apenas teste)")

if [ -z "$CHOICE" ]; then
    echo "Nenhuma opção de tradutor escolhida. Saindo."
    exit 0
fi

echo "Tradutor escolhido: $CHOICE"

# --- Configuração do Ambiente ---
export WINEPREFIX="$PREFIX_DIR"
export WINEDEBUG=-all

# Identificar arquitetura do executável
ARCH_INFO=$(file "$GAME_PATH")
if echo "$ARCH_INFO" | grep -q "x86-64"; then
    IS_64BIT="true"
    echo "Arquitetura detectada: 64-bit"
else
    IS_64BIT="false"
    echo "Arquitetura detectada: 32-bit"
fi

case "$CHOICE" in
    "Mesa3D + DXVK")
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d10core,d3d11,dxgi,opengl32=n,b"
        if [ "$IS_64BIT" = "true" ]; then
            export LD_LIBRARY_PATH="$BIN_X64:$LD_LIBRARY_PATH"
        else
            export LD_LIBRARY_PATH="$BIN_X32:$LD_LIBRARY_PATH"
        fi
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
echo "Iniciando Wine..."
zenity --info --text="Iniciando jogo com: $CHOICE\n\nArquivo: $(basename "$GAME_PATH")" --timeout=3 --title="DragonLauncher" &

# Executar o jogo e capturar saída do Wine no log
wine "$GAME_PATH" >> "$LOG_FILE" 2>&1

echo "Jogo finalizado em $(date)."
