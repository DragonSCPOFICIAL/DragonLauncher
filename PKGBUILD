# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=7
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'zenity' 'bash' 'file')
makedepends=('git')
source=("git+https://github.com/DragonSCPOFICIAL/DragonLauncher.git")
sha256sums=('SKIP')

package() {
  cd "$srcdir/DragonLauncher"
  
  # Criar diretórios
  install -d "$pkgdir/opt/$pkgname"
  install -d "$pkgdir/usr/bin"
  install -d "$pkgdir/usr/share/applications"
  
  # Copiar tudo para /opt/dragonlauncher
  cp -r * "$pkgdir/opt/$pkgname/"
  
  # Dar permissão total (Controle Total)
  chmod -R 777 "$pkgdir/opt/$pkgname"
  chmod +x "$pkgdir/opt/$pkgname/DragonLauncher.sh"
  
  # Criar o link para o comando no terminal
  ln -sf "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # Instalar o atalho no menu
  if [ -f "DragonLauncher.desktop" ]; then
    install -m 777 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  fi
}
