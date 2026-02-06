# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=2
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux, com tradução DirectX/OpenGL para hardware limitado."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'zenity' 'bash')
makedepends=('git')
# Usando fontes locais para evitar problemas de download e diretórios src/
source=("git+https://github.com/DragonSCPOFICIAL/DragonLauncher.git")
sha256sums=('SKIP')

pkgver() {
  cd "$pkgname"
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g' || echo "1.0.0"
}

build() {
  # No build step needed for this script-based launcher
  true
}

package() {
  cd "$srcdir/DragonLauncher"
  
  # Criar diretório de instalação
  install -d "$pkgdir/opt/$pkgname"
  
  # Copiar os arquivos principais
  install -m755 "DragonLauncher.sh" "$pkgdir/opt/$pkgname/"
  install -m644 "DragonLauncher.desktop" "$pkgdir/opt/$pkgname/"
  install -m644 "COMO_USAR.txt" "$pkgdir/opt/$pkgname/"
  install -m644 "comandos.txt" "$pkgdir/opt/$pkgname/"
  install -m644 "README.md" "$pkgdir/opt/$pkgname/"
  
  # Copiar configurações
  install -d "$pkgdir/opt/$pkgname/configs"
  if [ -d "configs" ]; then
    cp -r configs/* "$pkgdir/opt/$pkgname/configs/"
  fi
  
  # Copiar arquivos binários
  if [ -d "bin" ]; then
    cp -r "bin" "$pkgdir/opt/$pkgname/"
    chmod -R 755 "$pkgdir/opt/$pkgname/bin"
  else
    install -d "$pkgdir/opt/$pkgname/bin/x32"
    install -d "$pkgdir/opt/$pkgname/bin/x64"
  fi
  
  # Criar diretório para prefixo isolado
  install -d "$pkgdir/opt/$pkgname/prefixo_isolado"
  
  # Criar link simbólico para o executável principal
  install -d "$pkgdir/usr/bin"
  ln -s "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # Instalar o arquivo .desktop
  install -d "$pkgdir/usr/share/applications"
  install -m644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  
  # Ajustar caminhos no .desktop
  sed -i "s|Exec=.*|Exec=/usr/bin/dragonlauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
}
