#!/bin/bash

# DragonLauncher - Versão com Interface Melhorada
# Mantenedor: DragonSCPOFICIAL
# Detecta automaticamente todos os tradutores disponíveis

# 1. Configuração de Logs
LOG_FILE="$HOME/.dragonlauncher.log"
echo "--- DragonLauncher Iniciado em $(date) ---" > "$LOG_FILE"
exec 2>>"$LOG_FILE"

# 2. Verificação de Dependências
echo "Verificando dependências..." | tee -a "$LOG_FILE"

MISSING_DEPS=()
for cmd in python3 wine file; do
    if ! command -v "$cmd" &> /dev/null; then
        MISSING_DEPS+=("$cmd")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "ERRO: Dependências faltando: ${MISSING_DEPS[*]}" | tee -a "$LOG_FILE"
    
    # Tentar mostrar erro visual se possível
    if command -v zenity &> /dev/null; then
        zenity --error --title="DragonLauncher - Erro" \
               --text="Dependências faltando:\n\n${MISSING_DEPS[*]}\n\nInstale com:\nsudo pacman -S ${MISSING_DEPS[*]}" \
               --width=400
    fi
    exit 1
fi

# 3. Definir local da instalação
BASE_DIR="/opt/dragonlauncher"

if [ ! -d "$BASE_DIR" ]; then
    echo "Diretório /opt/dragonlauncher não encontrado, usando diretório local..." | tee -a "$LOG_FILE"
    BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

if [ ! -d "$BASE_DIR" ]; then
    echo "ERRO: Não foi possível localizar o DragonLauncher!" | tee -a "$LOG_FILE"
    
    if command -v zenity &> /dev/null; then
        zenity --error --title="DragonLauncher - Erro" \
               --text="Erro de instalação!\n\nDiretório não encontrado:\n$BASE_DIR\n\nReinstale o DragonLauncher." \
               --width=400
    fi
    exit 1
fi

cd "$BASE_DIR" || exit 1
echo "Executando de: $BASE_DIR" | tee -a "$LOG_FILE"

# 4. Verificar se interface.py existe
if [ ! -f "$BASE_DIR/interface.py" ]; then
    echo "ERRO: interface.py não encontrado!" | tee -a "$LOG_FILE"
    
    if command -v zenity &> /dev/null; then
        zenity --error --title="DragonLauncher - Erro" \
               --text="Arquivo interface.py não encontrado!\n\nReinstale o DragonLauncher." \
               --width=400
    fi
    exit 1
fi

# 5. Verificar se há tradutores disponíveis
if [ ! -d "$BASE_DIR/bin" ]; then
    echo "AVISO: Pasta bin/ não encontrada. Criando..." | tee -a "$LOG_FILE"
    mkdir -p "$BASE_DIR/bin/x32"
    mkdir -p "$BASE_DIR/bin/x64"
    
    if command -v zenity &> /dev/null; then
        zenity --warning --title="DragonLauncher - Aviso" \
               --text="Nenhum tradutor encontrado!\n\nA pasta bin/ está vazia.\n\nExecute:\nbash $BASE_DIR/download-bins.sh\n\nOu o jogo rodará apenas com Wine padrão." \
               --width=400
    fi
fi

# 6. Chamar a Interface Gráfica e capturar resultados
echo "Iniciando interface gráfica..." | tee -a "$LOG_FILE"

UI_OUTPUT=$(python3 "$BASE_DIR/interface.py" 2>&1)
UI_EXIT_CODE=$?

if [ $UI_EXIT_CODE -ne 0 ]; then
    echo "Interface fechada pelo usuário ou erro." | tee -a "$LOG_FILE"
    exit 0
fi

# 7. Extrair variáveis da saída da interface
eval "$UI_OUTPUT"

if [ -z "$GAME_PATH" ]; then
    echo "Nenhum jogo selecionado." | tee -a "$LOG_FILE"
    exit 0
fi

echo "Jogo selecionado: $GAME_PATH" | tee -a "$LOG_FILE"
echo "Tradutor escolhido: $CHOICE" | tee -a "$LOG_FILE"

# 8. Verificar se o jogo existe
if [ ! -f "$GAME_PATH" ]; then
    echo "ERRO: Jogo não encontrado: $GAME_PATH" | tee -a "$LOG_FILE"
    
    if command -v zenity &> /dev/null; then
        zenity --error --title="DragonLauncher - Erro" \
               --text="Arquivo não encontrado:\n\n$GAME_PATH" \
               --width=400
    fi
    exit 1
fi

# 9. Configurar Ambiente Wine
export WINEPREFIX="$HOME/.dragonlauncher_prefix"
mkdir -p "$WINEPREFIX"

echo "Wine Prefix: $WINEPREFIX" | tee -a "$LOG_FILE"

# 10. Detectar arquitetura do jogo
if [ "$ARCH" = "auto" ]; then
    echo "Detectando arquitetura do jogo..." | tee -a "$LOG_FILE"
    
    if file "$GAME_PATH" | grep -q "x86-64"; then
        DETECTED_ARCH="x64"
        echo "Detectado: 64 bits" | tee -a "$LOG_FILE"
    else
        DETECTED_ARCH="x32"
        echo "Detectado: 32 bits" | tee -a "$LOG_FILE"
    fi
else
    DETECTED_ARCH="$ARCH"
    echo "Arquitetura manual: $DETECTED_ARCH" | tee -a "$LOG_FILE"
fi

BIN_DIR="$BASE_DIR/bin/$DETECTED_ARCH"

# 11. Verificar se a pasta de binários existe
if [ ! -d "$BIN_DIR" ]; then
    echo "AVISO: Pasta $BIN_DIR não existe. Criando..." | tee -a "$LOG_FILE"
    mkdir -p "$BIN_DIR"
fi

# 12. Aplicar configurações do tradutor escolhido
echo "Configurando tradutor: $CHOICE" | tee -a "$LOG_FILE"

# Se WINEDLLOVERRIDES já foi definido pela interface, usar ele
if [ -z "$WINEDLLOVERRIDES" ]; then
    case "$CHOICE" in
        *"Mesa3D + DXVK"*)
            export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d11,dxgi,opengl32=n,b"
            export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            ;;
        *"DXVK"*)
            export WINEDLLOVERRIDES="d3d8,d3d9,d3d10,d3d11,dxgi=n,b"
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
        *"Mesa3D"*)
            export WINEDLLOVERRIDES="opengl32=n,b"
            export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
            ;;
        *"Wine"*|"Padrão"*)
            # Sem overrides, Wine puro
            echo "Usando Wine padrão (sem tradutores)" | tee -a "$LOG_FILE"
            ;;
        *)
            # Tradutor desconhecido, mas pode ter DLLs customizadas
            if [ -d "$BIN_DIR" ] && [ "$(ls -A $BIN_DIR)" ]; then
                export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
                echo "Usando DLLs de: $BIN_DIR" | tee -a "$LOG_FILE"
            fi
            ;;
    esac
else
    # Usar override definido pela interface
    export WINEDLLOVERRIDES
    export LD_LIBRARY_PATH="$BIN_DIR:$LD_LIBRARY_PATH"
fi

echo "WINEDLLOVERRIDES: $WINEDLLOVERRIDES" | tee -a "$LOG_FILE"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH" | tee -a "$LOG_FILE"

# 13. Iniciar o jogo
echo "================================================" | tee -a "$LOG_FILE"
echo "Iniciando: $GAME_PATH" | tee -a "$LOG_FILE"
echo "Tradutor: $CHOICE" | tee -a "$LOG_FILE"
echo "Arquitetura: $DETECTED_ARCH" | tee -a "$LOG_FILE"
echo "================================================" | tee -a "$LOG_FILE"

# Executar o jogo
wine "$GAME_PATH" >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

echo "================================================" | tee -a "$LOG_FILE"
echo "Jogo finalizado com código: $EXIT_CODE" | tee -a "$LOG_FILE"
echo "--- DragonLauncher Finalizado em $(date) ---" | tee -a "$LOG_FILE"

# 14. Mostrar mensagem se houver erro
if [ $EXIT_CODE -ne 0 ]; then
    if command -v zenity &> /dev/null; then
        zenity --error --title="DragonLauncher - Erro" \
               --text="O jogo encerrou com erro (código $EXIT_CODE)\n\nVerifique o log:\n$LOG_FILE" \
               --width=400
    fi
fi

exit $EXIT_CODE
