# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=8
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
  
  # 1. Criar estrutura de diretórios com permissões máximas
  install -d -m 777 "$pkgdir/opt/$pkgname"
  install -d -m 777 "$pkgdir/usr/bin"
  install -d -m 777 "$pkgdir/usr/share/applications"
  
  # 2. Copiar absolutamente todos os arquivos do repositório
  cp -r * "$pkgdir/opt/$pkgname/"
  
  # 3. Garantir Controle Total (777) em todos os arquivos instalados
  chmod -R 777 "$pkgdir/opt/$pkgname"
  
  # 4. Garantir que o script principal seja executável
  chmod +x "$pkgdir/opt/$pkgname/DragonLauncher.sh"
  
  # 5. Criar link simbólico no sistema para rodar via terminal
  ln -sf "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # 6. Instalar o atalho .desktop com permissões de execução
  if [ -f "DragonLauncher.desktop" ]; then
    install -m 777 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    # Garantir que o atalho aponte para o caminho correto e use o bash
    sed -i "s|Exec=.*|Exec=/bin/bash /opt/$pkgname/DragonLauncher.sh|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  fi
}
