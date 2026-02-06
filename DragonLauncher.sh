#!/bin/bash

# DragonLauncher - Versão Robusta e Estável
# Mantenedor: DragonSCPOFICIAL

# 1. Configuração de Logs
LOG_FILE="$HOME/.dragonlauncher.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "--- DragonLauncher Iniciado em $(date) ---"

# 2. Verificação de Dependências Críticas
check_dependencies() {
    local missing_deps=()
    for cmd in zenity wine file; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "ERRO: Dependências ausentes: ${missing_deps[*]}"
        if command -v notify-send &> /dev/null; then
            notify-send "DragonLauncher" "Erro: Instale as dependências: ${missing_deps[*]}"
        fi
        exit 1
    fi
}

check_dependencies

# 3. Definir local da instalação e verificar integridade
BASE_DIR="/opt/dragonlauncher"
if [ ! -d "$BASE_DIR" ]; then
    # Se não estiver em /opt, tenta o diretório local (para desenvolvimento/portabilidade)
    BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
    echo "Aviso: /opt/dragonlauncher não encontrado. Usando diretório local: $BASE_DIR"
fi

cd "$BASE_DIR" || {
    zenity --error --text="Não foi possível acessar o diretório do programa: $BASE_DIR"
    exit 1
}

# 4. Selecionar o Jogo
GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe *.EXE")

if [ -z "$GAME_PATH" ]; then
    echo "Nenhum jogo selecionado. Saindo..."
    exit 0
fi

# 5. Escolher Tradutor
CHOICE=$(zenity --list --radiolist --title="DragonLauncher - Escolha o Tradutor" \
    --column="Seleção" --column="Opção" --column="Descrição" \
    TRUE "Mesa3D + DXVK" "Melhor performance (Vulkan/OpenGL)" \
    FALSE "dgVoodoo2" "Ideal para Jogos Antigos (DirectX 1-8)" \
    FALSE "Padrão Wine" "Sem tradutor adicional")

if [ -z "$CHOICE" ]; then
    echo "Nenhuma opção escolhida. Saindo..."
    exit 0
fi

# 6. Configurar Ambiente
export WINEPREFIX="$HOME/.dragonlauncher_prefix"
mkdir -p "$WINEPREFIX"

# Detectar arquitetura do jogo
if file "$GAME_PATH" | grep -q "x86-64"; then
    echo "Detectado jogo 64-bit"
    BIN_DIR="$BASE_DIR/bin/x64"
else
    echo "Detectado jogo 32-bit"
    BIN_DIR="$BASE_DIR/bin/x32"
fi

# Verificar se os binários existem
if [ ! -d "$BIN_DIR" ] || [ -z "$(ls -A "$BIN_DIR" 2>/dev/null)" ]; then
    zenity --warning --text="Aviso: Os binários de tradução não foram encontrados em $BIN_DIR.\nO jogo tentará rodar com o Wine padrão."
    echo "Aviso: Binários ausentes em $BIN_DIR"
fi

# 7. Aplicar Overrides e Rodar
case "$CHOICE" in
    "Mesa3D + DXVK")
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d11,dxgi,opengl32=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        echo "Iniciando com Mesa3D + DXVK..."
        ;;
    "dgVoodoo2")
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        echo "Iniciando com dgVoodoo2..."
        ;;
    *)
        echo "Iniciando com Wine Padrão..."
        ;;
esac

echo "Executando: wine $GAME_PATH"
wine "$GAME_PATH"

echo "--- DragonLauncher Finalizado em $(date) ---"
