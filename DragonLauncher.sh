#!/bin/bash

# DragonLauncher - Script de Compatibilidade Ultra-Robusto
# Mantenedor: DragonSCPOFICIAL

# 1. Garantir que estamos no diretório correto e temos permissões
SCRIPT_PATH=$(readlink -f "$0")
BASE_DIR=$(dirname "$SCRIPT_PATH")
cd "$BASE_DIR" || exit 1

# 2. Sistema de Log (para diagnóstico se algo falhar)
LOG_FILE="$HOME/.dragonlauncher.log"
echo "--- Iniciando DragonLauncher: $(date) ---" > "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

# 3. Verificação de Dependência Crítica (Interface)
if ! command -v zenity &> /dev/null; then
    echo "ERRO: Zenity não encontrado. Tentando avisar o usuário..."
    # Se o zenity não existe, não temos como mostrar interface.
    exit 1
fi

# 4. Interface Principal - Seleção de Jogo
# Usamos um loop para garantir que a interface não feche sem motivo
while true; do
    GAME_PATH=$(zenity --file-selection --title="DragonLauncher - Selecione o Jogo (.exe)" --file-filter="Executáveis Windows | *.exe *.EXE")
    
    if [ -z "$GAME_PATH" ]; then
        echo "Seleção cancelada pelo usuário."
        exit 0
    fi

    if [ -f "$GAME_PATH" ]; then
        break
    else
        zenity --error --text="Arquivo não encontrado: $GAME_PATH" --title="Erro de Seleção"
    fi
done

# 5. Interface de Seleção de Tradutor
CHOICE=$(zenity --list --radiolist --title="DragonLauncher - Escolha o Tradutor" \
    --width=500 --height=300 \
    --column="Seleção" --column="Opção" --column="Descrição" \
    TRUE "Mesa3D + DXVK" "Melhor performance (Vulkan/OpenGL moderno)" \
    FALSE "dgVoodoo2" "Melhor compatibilidade para jogos antigos (DX 1-8)" \
    FALSE "Padrão Wine" "Sem tradutores customizados (Apenas teste)")

if [ -z "$CHOICE" ]; then
    echo "Nenhuma opção escolhida. Saindo."
    exit 0
fi

# 6. Configuração de Ambiente
export WINEPREFIX="$HOME/.dragonlauncher_prefix"
mkdir -p "$WINEPREFIX"
export WINEDEBUG=-all

# Detectar Arquitetura
ARCH_INFO=$(file "$GAME_PATH")
if echo "$ARCH_INFO" | grep -q "x86-64"; then
    BIN_DIR="$BASE_DIR/bin/x64"
    echo "Arquitetura: 64-bit"
else
    BIN_DIR="$BASE_DIR/bin/x32"
    echo "Arquitetura: 32-bit"
fi

# Aplicar Tradutores
case "$CHOICE" in
    "Mesa3D + DXVK")
        export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d10core,d3d11,dxgi,opengl32=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        ;;
    "dgVoodoo2")
        export WINEDLLOVERRIDES="ddraw,d3dimm,d3d8,d3d9=n,b"
        export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
        ;;
    "Padrão Wine")
        export WINEDLLOVERRIDES=""
        ;;
esac

# 7. Execução Final
zenity --info --text="Iniciando jogo com: $CHOICE\nAguarde..." --timeout=2 --title="DragonLauncher" &
wine "$GAME_PATH"
