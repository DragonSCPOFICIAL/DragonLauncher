#!/bin/bash

# DragonLauncher - Script de Instalação Manual
# Este script instala o DragonLauncher no sistema (/opt/dragonlauncher)

echo "=========================================="
echo "   DragonLauncher - Instalador Manual"
echo "=========================================="
echo ""

# Verificar se está executando como root
if [ "$EUID" -ne 0 ]; then
    echo "ERRO: Por favor, execute como root (use sudo)."
    echo "Exemplo: sudo ./install.sh"
    exit 1
fi

INSTALL_DIR="/opt/dragonlauncher"
BIN_LINK="/usr/bin/dragonlauncher"
APP_ENTRY="/usr/share/applications/dragonlauncher.desktop"

echo "Iniciando instalação em $INSTALL_DIR..."

# 1. Criar diretório de instalação
mkdir -p "$INSTALL_DIR"

# 2. Copiar arquivos
echo "[1/5] Copiando arquivos..."
cp -r ./* "$INSTALL_DIR/"

# 3. Configurar permissões
echo "[2/5] Configurando permissões..."
chmod -R 777 "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/DragonLauncher.sh"
chmod +x "$INSTALL_DIR/uninstall.sh"
chmod +x "$INSTALL_DIR/update.sh"
chmod +x "$INSTALL_DIR/updater.py"
chmod +x "$INSTALL_DIR/install.sh"
chmod +x "$INSTALL_DIR/download-bins.sh"

# 4. Criar link simbólico
echo "[3/5] Criando atalho no sistema (/usr/bin/dragonlauncher)..."
ln -sf "$INSTALL_DIR/DragonLauncher.sh" "$BIN_LINK"

# 5. Configurar entrada no menu (Desktop Entry)
echo "[4/5] Configurando atalho no menu de aplicativos..."
if [ -f "$INSTALL_DIR/DragonLauncher.desktop" ]; then
    cp "$INSTALL_DIR/DragonLauncher.desktop" "$APP_ENTRY"
    sed -i "s|Exec=.*|Exec=$BIN_LINK|" "$APP_ENTRY"
    sed -i "s|Path=.*|Path=$INSTALL_DIR|" "$APP_ENTRY"
    chmod 644 "$APP_ENTRY"
fi

# 6. Baixar binários iniciais (opcional)
echo "[5/5] Verificando binários..."
cd "$INSTALL_DIR"
if [ -f "./download-bins.sh" ]; then
    ./download-bins.sh
fi

echo ""
echo "=========================================="
echo "   Instalação concluída com sucesso!"
echo "=========================================="
echo "Você pode iniciar o programa digitando 'dragonlauncher' no terminal"
echo "ou procurando por 'DragonLauncher' no seu menu de aplicativos."
echo ""
