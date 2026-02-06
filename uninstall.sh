#!/bin/bash

# DragonLauncher - Desinstalador Completo
# Este script remove todos os arquivos do sistema e configurações do usuário.

echo "========================================"
echo "   DRAGON LAUNCHER - DESINSTALADOR      "
echo "========================================"

# Verificar se é root, se não, pedir sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, insira sua senha para desinstalar o programa do sistema."
  sudo "$0" "$@"
  exit $?
fi

echo "Iniciando remoção completa..."

# 1. Remover diretório principal
if [ -d "/opt/dragonlauncher" ]; then
    echo "[-] Removendo /opt/dragonlauncher..."
    rm -rf "/opt/dragonlauncher"
fi

# 2. Remover binário do sistema
if [ -f "/usr/bin/dragonlauncher" ]; then
    echo "[-] Removendo /usr/bin/dragonlauncher..."
    rm -f "/usr/bin/dragonlauncher"
fi

# 3. Remover atalho do menu
if [ -f "/usr/share/applications/DragonLauncher.desktop" ]; then
    echo "[-] Removendo atalho do menu..."
    rm -f "/usr/share/applications/DragonLauncher.desktop"
fi

# 4. Limpar arquivos do usuário (Configurações e Logs)
# Como estamos como sudo, precisamos pegar o usuário real para limpar a home dele
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo "[-] Limpando configurações do usuário ($REAL_USER)..."
rm -rf "$USER_HOME/.config/dragonlauncher"
rm -rf "$USER_HOME/.dragonlauncher_backup"
rm -rf "$USER_HOME/.dragonlauncher_update"
rm -f "$USER_HOME/.dragonlauncher.log"
rm -f "$USER_HOME/.dragonlauncher_update.log"

# 5. Pergunta sobre o Prefixo Wine (Opcional pois contém os jogos)
echo ""
read -p "Deseja remover também a pasta de jogos/prefixo Wine? (y/N): " REMOVE_WINE
if [[ "$REMOVE_WINE" =~ ^[Yy]$ ]]; then
    echo "[-] Removendo prefixo Wine em $USER_HOME/.dragonlauncher_prefix..."
    rm -rf "$USER_HOME/.dragonlauncher_prefix"
fi

echo "----------------------------------------"
echo "SUCESSO: DragonLauncher foi totalmente removido!"
echo "Pressione Enter para fechar."
read
