#!/bin/bash

# Script para baixar os arquivos binários do DragonLauncher
# Este script é executado durante a instalação via makepkg

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
X32_DIR="$BIN_DIR/x32"
X64_DIR="$BIN_DIR/x64"

# URL base para os arquivos (pode ser alterada conforme necessário)
GITHUB_RELEASE_URL="https://github.com/DragonSCPOFICIAL/DragonLauncher/releases/download/v1.0.0"

echo "Criando diretórios para binários..."
mkdir -p "$X32_DIR"
mkdir -p "$X64_DIR"

# Função para baixar arquivo
download_file() {
    local url="$1"
    local dest="$2"
    local filename=$(basename "$dest")
    
    if [ -f "$dest" ]; then
        echo "✓ $filename já existe, pulando..."
        return 0
    fi
    
    echo "Baixando $filename..."
    if wget -q --show-progress "$url" -O "$dest"; then
        echo "✓ $filename baixado com sucesso"
    else
        echo "✗ Erro ao baixar $filename"
        return 1
    fi
}

# Lista de arquivos x32
echo "Baixando arquivos x32..."
X32_FILES=(
    "D3D8.dll"
    "D3D9.dll"
    "D3DImm.dll"
    "DDraw.dll"
    "Glide.dll"
    "Glide2x.dll"
    "Glide3x.dll"
    "clon12compiler.dll"
    "d3d10core.dll"
    "d3d10warp.dll"
    "d3d11.dll"
    "d3d8.dll"
    "d3d9.dll"
    "dxgi.dll"
    "dxil.dll"
    "libEGL.dll"
    "libGLESv1_CM.dll"
    "libGLESv2.dll"
    "libgallium_wgl.dll"
    "msav1enchmft.dll"
    "msh264enchmft.dll"
    "msh265enchmft.dll"
    "openclon12.dll"
    "opengl32.dll"
    "spirv_to_dxil.dll"
    "va.dll"
    "va_win32.dll"
    "vaon12_drv_video.dll"
    "vulkan_dzn.dll"
    "vulkan_lvp.dll"
)

for file in "${X32_FILES[@]}"; do
    download_file "$GITHUB_RELEASE_URL/x32-$file" "$X32_DIR/$file" || true
done

# Lista de arquivos x64
echo "Baixando arquivos x64..."
X64_FILES=(
    "D3D9.dll"
    "Glide.dll"
    "Glide2x.dll"
    "Glide3x.dll"
    "VkLayer_MESA_anti_lag.dll"
    "clon12compiler.dll"
    "d3d10core.dll"
    "d3d10warp.dll"
    "d3d11.dll"
    "d3d8.dll"
    "d3d9.dll"
    "dxgi.dll"
    "dxil.dll"
    "libEGL.dll"
    "libGLESv1_CM.dll"
    "libGLESv2.dll"
    "libgallium_wgl.dll"
    "msav1enchmft.dll"
    "msh264enchmft.dll"
    "msh265enchmft.dll"
    "openclon12.dll"
    "opengl32.dll"
    "spirv_to_dxil.dll"
    "va.dll"
    "va_win32.dll"
    "vaon12_drv_video.dll"
    "vulkan_dzn.dll"
    "vulkan_lvp.dll"
)

for file in "${X64_FILES[@]}"; do
    download_file "$GITHUB_RELEASE_URL/x64-$file" "$X64_DIR/$file" || true
done

# dgVoodooCpl.exe removido temporariamente para evitar erro de download
# echo "Baixando dgVoodooCpl.exe..."
# download_file "$GITHUB_RELEASE_URL/dgVoodooCpl.exe" "$BIN_DIR/dgVoodooCpl.exe" || true

echo "✓ Download de binários concluído!"
