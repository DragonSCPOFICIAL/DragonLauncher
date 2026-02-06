#!/bin/bash

# DragonLauncher - Versao com Interface Dedicada
# Mantenedor: DragonSCPOFICIAL

# 1. Configuracao de Logs
LOG_FILE="$HOME/.dragonlauncher.log"
echo "--- DragonLauncher Iniciado em $(date) ---" > "$LOG_FILE"
exec 2>>"$LOG_FILE"

# 2. Verificacao de Dependencias
for cmd in python3 wine file; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERRO: $cmd nao encontrado!" | tee -a "$LOG_FILE"
        exit 1
    fi
done

# 3. Definir local da instalacao
BASE_DIR="/opt/dragonlauncher"
if [ ! -d "$BASE_DIR" ]; then
    BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
cd "$BASE_DIR" || exit 1

# 4. Chamar a Interface Grafica e capturar resultados
UI_OUTPUT=$(python3 "$BASE_DIR/interface.py")

# Extrair variaveis da saida da interface
eval "$UI_OUTPUT"

if [ -z "$GAME_PATH" ]; then
    echo "Nenhum jogo selecionado ou interface fechada." >> "$LOG_FILE"
    exit 0
fi

# 5. Configurar Ambiente
export WINEPREFIX="$HOME/.dragonlauncher_prefix"
mkdir -p "$WINEPREFIX"

# Detectar arquitetura
if file "$GAME_PATH" | grep -q "x86-64"; then
    BIN_DIR="$BASE_DIR/bin/x64"
else
    BIN_DIR="$BASE_DIR/bin/x32"
fi

# 6. Aplicar Overrides e Rodar
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

echo "Iniciando: $GAME_PATH com $CHOICE" >> "$LOG_FILE"
wine "$GAME_PATH" >> "$LOG_FILE" 2>&1

echo "--- DragonLauncher Finalizado em $(date) ---" >> "$LOG_FILE"
