#!/bin/bash
# DragonLauncher Update Script
# Script simples para atualizar o DragonLauncher

echo "=========================================="
echo "   DragonLauncher - Sistema de Atualização"
echo "=========================================="
echo ""

# Verificar se está executando como root
if [ "$EUID" -eq 0 ]; then
    echo "AVISO: Não execute este script como root!"
    echo "Execute como usuário normal."
    exit 1
fi

# Definir diretório base
BASE_DIR="/opt/dragonlauncher"
if [ ! -d "$BASE_DIR" ]; then
    BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

# Verificar se o updater existe
UPDATER="$BASE_DIR/updater.py"
if [ ! -f "$UPDATER" ]; then
    echo "ERRO: Script de atualização não encontrado!"
    echo "Caminho esperado: $UPDATER"
    echo ""
    echo "Tentando atualização manual via git..."
    
    if [ -d "$HOME/DragonLauncher/.git" ]; then
        cd "$HOME/DragonLauncher" || exit 1
        echo "Atualizando repositório..."
        git pull
        echo ""
        echo "Reinstalando pacote..."
        makepkg -si --noconfirm
    else
        echo "Repositório não encontrado em $HOME/DragonLauncher"
        echo ""
        echo "Para atualizar manualmente, execute:"
        echo "  cd ~/DragonLauncher"
        echo "  git pull"
        echo "  makepkg -si --noconfirm"
    fi
    exit 1
fi

# Executar o updater Python
echo "Iniciando verificação de atualizações..."
echo ""

python3 "$UPDATER" "$@"
EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "Atualização concluída com sucesso!"
else
    echo "Atualização falhou ou foi cancelada."
fi

echo ""
read -p "Pressione Enter para sair..."
exit $EXIT_CODE
