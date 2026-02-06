#!/bin/bash

# DragonLauncher - Script Principal de Execução
# Este script gerencia a interface e a execução dos jogos com tradutores.

LOG_FILE="$HOME/.dragonlauncher.log"
echo "--- DragonLauncher Iniciado em $(date) ---" > "$LOG_FILE"
exec 2>>"$LOG_FILE"

BASE_DIR="/opt/dragonlauncher"
[ ! -d "$BASE_DIR" ] && BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Função para executar o jogo
launch_game() {
    local GAME_PATH="$1"
    local CHOICE="$2"
    local ARCH="$3"

    echo "Iniciando Jogo: $GAME_PATH" | tee -a "$LOG_FILE"
    echo "Tradutor: $CHOICE" | tee -a "$LOG_FILE"
    echo "Arquitetura: $ARCH" | tee -a "$LOG_FILE"

    export WINEPREFIX="$HOME/.dragonlauncher_prefix"
    mkdir -p "$WINEPREFIX"

    # Definir diretório de binários
    local DETECTED_ARCH="x64"
    [[ "$ARCH" == *"32"* ]] && DETECTED_ARCH="x32"
    
    local BIN_DIR="$BASE_DIR/bin/$DETECTED_ARCH"
    
    # Configurar Overrides baseados no tradutor
    case "$CHOICE" in
        *"DXVK"*)
            export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d11,dxgi=n,b"
            export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            ;;
        *"Mesa3D"*)
            export WINEDLLOVERRIDES="opengl32=n,b"
            export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            ;;
        *"dgVoodoo"*)
            export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
            export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            ;;
        *"VKD3D"*)
            export WINEDLLOVERRIDES="d3d12=n,b"
            export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            ;;
        *)
            # Se houver DLLs na pasta, tenta carregar
            if [ -d "$BIN_DIR" ]; then
                export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            fi
            ;;
    esac

    # Entrar no diretório do jogo para evitar erros de DLLs locais
    cd "$(dirname "$GAME_PATH")" || exit 1
    
    # Executar
    wine "$GAME_PATH" >> "$LOG_FILE" 2>&1
    local EXIT_CODE=$?
    
    echo "Jogo finalizado com código: $EXIT_CODE" | tee -a "$LOG_FILE"
    return $EXIT_CODE
}

# Se houver argumentos, executa o jogo diretamente
if [ "$1" == "--launch" ]; then
    launch_game "$2" "$3" "$4"
    exit $?
fi

# Caso contrário, abre a interface
python3 "$BASE_DIR/interface.py"
