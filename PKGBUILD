# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.1.1
pkgrel=1
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux com interface dedicada e sistema de atualização automática."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'python' 'python-pillow' 'tk' 'bash' 'file' 'wget')
makedepends=('git')
source=("git+https://github.com/DragonSCPOFICIAL/DragonLauncher.git")
sha256sums=('SKIP')

prepare() {
  cd "$srcdir/DragonLauncher"
  chmod +x download-bins.sh
  ./download-bins.sh
}

package() {
  cd "$srcdir/DragonLauncher"
  
  install -d "$pkgdir/opt/$pkgname"
  install -d "$pkgdir/usr/bin"
  install -d "$pkgdir/usr/share/applications"
  
  cp -r * "$pkgdir/opt/$pkgname/"
  
  chmod -R 777 "$pkgdir/opt/$pkgname"
  chmod +x "$pkgdir/opt/$pkgname/DragonLauncher.sh"
  chmod +x "$pkgdir/opt/$pkgname/uninstall.sh"
  chmod +x "$pkgdir/opt/$pkgname/update.sh"
  chmod +x "$pkgdir/opt/$pkgname/updater.py"
  
  ln -sf "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  if [ -f "DragonLauncher.desktop" ]; then
    install -m 644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Exec=.*|Exec=/usr/bin/dragonlauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  fi
}
