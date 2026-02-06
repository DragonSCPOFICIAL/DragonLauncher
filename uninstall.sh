#!/bin/bash

# DragonLauncher - Script de Desinstalação Completa
# Este script remove todos os arquivos, configurações e binários do sistema.

echo "=========================================="
echo "   DragonLauncher - Desinstalador"
echo "=========================================="
echo ""

# Verificar se o usuário realmente deseja desinstalar
if [[ "$1" != "--force" ]]; then
    read -p "Tem certeza que deseja remover COMPLETAMENTE o DragonLauncher? (s/N): " confirm
    if [[ ! $confirm =~ ^[Ss]$ ]]; then
        echo "Desinstalação cancelada."
        exit 0
    fi
fi

echo "Iniciando remoção..."

# 1. Remover links simbólicos em /usr/bin
echo "[1/6] Removendo atalhos do sistema..."
if [ -L "/usr/bin/dragonlauncher" ]; then
    sudo rm -f "/usr/bin/dragonlauncher"
    echo "  - /usr/bin/dragonlauncher removido."
fi

# 2. Remover arquivos de desktop (menu de aplicativos)
echo "[2/6] Removendo atalhos do menu..."
if [ -f "/usr/share/applications/dragonlauncher.desktop" ]; then
    sudo rm -f "/usr/share/applications/dragonlauncher.desktop"
    echo "  - Atalho do menu removido."
fi

# 3. Remover diretório principal em /opt
echo "[3/6] Removendo arquivos do programa (/opt/dragonlauncher)..."
if [ -d "/opt/dragonlauncher" ]; then
    sudo rm -rf "/opt/dragonlauncher"
    echo "  - Diretório /opt/dragonlauncher removido."
fi

# 4. Remover arquivos de configuração e logs do usuário
echo "[4/6] Removendo logs e configurações do usuário..."
rm -f "$HOME/.dragonlauncher.log"
rm -f "$HOME/.dragonlauncher_update.log"
echo "  - Logs removidos."

# 5. Remover backups e arquivos temporários de atualização
echo "[5/6] Removendo backups e arquivos temporários..."
rm -rf "$HOME/.dragonlauncher_backup"
rm -rf "$HOME/.dragonlauncher_update"
echo "  - Backups e temporários removidos."

# 6. Remover o prefixo do Wine (Opcional)
echo ""
if [[ "$1" != "--force" ]]; then
    read -p "Deseja remover também o prefixo do Wine (~/.dragonlauncher_prefix)? Isso apagará todos os jogos instalados por ele! (s/N): " remove_prefix
    if [[ $remove_prefix =~ ^[Ss]$ ]]; then
        echo "[6/6] Removendo prefixo do Wine..."
        rm -rf "$HOME/.dragonlauncher_prefix"
        echo "  - Prefixo removido."
    else
        echo "[6/6] Prefixo do Wine mantido em $HOME/.dragonlauncher_prefix"
    fi
else
    echo "[6/6] Prefixo do Wine mantido (use remoção manual se desejar apagar os jogos)."
fi

echo ""
echo "=========================================="
echo "   Desinstalação concluída com sucesso!"
echo "=========================================="
echo "O DragonLauncher foi removido do seu sistema."
echo ""
