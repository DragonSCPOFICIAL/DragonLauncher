#!/bin/bash

# DragonLauncher - Versão Corrigida
# Mantenedor: DragonSCPOFICIAL

# 1. Sistema de Logs (Prometido no README)
LOG_FILE="$HOME/.dragonlauncher.log"
echo "--- DragonLauncher Iniciado em $(date) ---" > "$LOG_FILE"

# Redirecionar erros para o log sem travar a saída padrão
exec 2>>"$LOG_FILE"

# 2. Verificação de Dependências (Evita o travamento silencioso)
for cmd in zenity wine file; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERRO: $cmd não encontrado! Instale com: sudo pacman -S $cmd" | tee -a "$LOG_FILE"
        # Tenta avisar visualmente se o notify-send existir, senão apenas loga
        if command -v notify-send &> /dev/null; then
            notify-send "DragonLauncher" "Erro: $cmd não encontrado. Instale as dependências."
        fi
        exit 1
    fi
done

# 3. Definir local da instalação e verificar diretório
BASE_DIR="/opt/dragonlauncher"
if [ ! -d "$BASE_DIR" ]; then
    echo "ERRO: Diretório $BASE_DIR não encontrado!" | tee -a "$LOG_FILE"
    zenity --error --text="Erro: O diretório de instalação /opt/dragonlauncher não existe.\nPor favor, reinstale o programa."
    exit 1
fi

cd "$BASE_DIR" || exit 1

# 4. Selecionar o Jogo
# O Zenity pode falhar se não houver servidor X ou Wayland ativo
GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe *.EXE")

if [ -z "$GAME_PATH" ]; then
    echo "Seleção cancelada pelo usuário." >> "$LOG_FILE"
    exit 0
fi

# 5. Escolher Tradutor
CHOICE=$(zenity --list --radiolist --title="DragonLauncher - Escolha o Tradutor" \
    --column="Seleção" --column="Opção" --column="Descrição" \
    TRUE "Mesa3D + DXVK" "Melhor performance" \
    FALSE "dgVoodoo2" "Jogos Antigos" \
    FALSE "Padrão Wine" "Sem tradutor")

if [ -z "$CHOICE" ]; then
    echo "Nenhuma opção de tradutor escolhida." >> "$LOG_FILE"
    exit 0
fi

# 6. Configurar e Rodar
export WINEPREFIX="$HOME/.dragonlauncher_prefix"
mkdir -p "$WINEPREFIX"

# Detectar se é 64 ou 32 bits para usar as DLLs certas
if file "$GAME_PATH" | grep -q "x86-64"; then
    echo "Detectado: Jogo 64-bit" >> "$LOG_FILE"
    BIN_DIR="$BASE_DIR/bin/x64"
else
    echo "Detectado: Jogo 32-bit" >> "$LOG_FILE"
    BIN_DIR="$BASE_DIR/bin/x32"
fi

# Verificar se as pastas de binários existem e não estão vazias
if [ ! -d "$BIN_DIR" ] || [ -z "$(ls -A "$BIN_DIR" 2>/dev/null)" ]; then
    echo "AVISO: Binários em $BIN_DIR não encontrados ou vazios." >> "$LOG_FILE"
    zenity --warning --text="Aviso: Os arquivos de tradução não foram encontrados.\nO jogo será executado com o Wine padrão."
fi

case "$CHOICE" in
    "Mesa3D + DXVK")
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d11,dxgi,opengl32=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        echo "Usando Mesa3D + DXVK" >> "$LOG_FILE"
        ;;
    "dgVoodoo2")
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        echo "Usando dgVoodoo2" >> "$LOG_FILE"
        ;;
    *)
        echo "Usando Wine Padrão" >> "$LOG_FILE"
        ;;
esac

echo "Executando: wine $GAME_PATH" >> "$LOG_FILE"
wine "$GAME_PATH" >> "$LOG_FILE" 2>&1

echo "--- DragonLauncher Finalizado em $(date) ---" >> "$LOG_FILE"
