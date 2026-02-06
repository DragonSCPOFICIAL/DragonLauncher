# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=9
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
  
  # 1. Criar estrutura de diretórios (usando permissões padrão do sistema para pastas globais)
  install -d "$pkgdir/opt/$pkgname"
  install -d "$pkgdir/usr/bin"
  install -d "$pkgdir/usr/share/applications"
  
  # 2. Copiar arquivos
  cp -r * "$pkgdir/opt/$pkgname/"
  
  # 3. Garantir que o script e a pasta do programa tenham permissões totais
  chmod -R 777 "$pkgdir/opt/$pkgname"
  chmod +x "$pkgdir/opt/$pkgname/DragonLauncher.sh"
  
  # 4. Criar link simbólico
  ln -sf "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # 5. Instalar o atalho .desktop
  if [ -f "DragonLauncher.desktop" ]; then
    install -m 644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Exec=.*|Exec=/bin/bash /opt/$pkgname/DragonLauncher.sh|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  fi
}
