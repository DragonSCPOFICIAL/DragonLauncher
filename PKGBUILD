# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=1
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux, com tradução DirectX/OpenGL para hardware limitado."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'zenity' 'bash')
makedepends=('git')
source=("$pkgname-$pkgver.tar.gz::https://github.com/DragonSCPOFICIAL/DragonLauncher/archive/refs/heads/main.tar.gz")
sha256sums=('SKIP')

build() {
  cd "$srcdir/DragonLauncher-main"
}

package() {
  cd "$srcdir/DragonLauncher-main"
  
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
  install -m644 "configs/"* "$pkgdir/opt/$pkgname/configs/" 2>/dev/null || true
  
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
  
  # Criar link simbólico para o executável principal em /usr/local/bin
  install -d "$pkgdir/usr/local/bin"
  ln -s "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/local/bin/dragonlauncher"
  
  # Instalar o arquivo .desktop no diretório de aplicações
  install -d "$pkgdir/usr/share/applications"
  install -m644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  
  # Atualizar o arquivo .desktop para apontar para o novo local
  sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  sed -i "s|Exec=.*|Exec=/usr/local/bin/dragonlauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  sed -i "s|Name=.*|Name=DragonLauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  sed -i "s|Comment=.*|Comment=Emulador de compatibilidade para jogos Windows|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
}
