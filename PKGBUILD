# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=11
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'zenity' 'bash' 'file' 'wget')
makedepends=('git')
source=("git+https://github.com/DragonSCPOFICIAL/DragonLauncher.git")
sha256sums=('SKIP')

prepare() {
  cd "$srcdir/DragonLauncher"
  # Garantir que o script de download tenha permissão de execução
  chmod +x download-bins.sh
  # O download-bins.sh deve ser executado para garantir que os binários existam antes do empacotamento
  ./download-bins.sh
}

package() {
  cd "$srcdir/DragonLauncher"
  
  # 1. Criar estrutura de diretórios
  install -d "$pkgdir/opt/$pkgname"
  install -d "$pkgdir/usr/bin"
  install -d "$pkgdir/usr/share/applications"
  
  # 2. Copiar arquivos (incluindo a pasta bin preenchida pelo download-bins.sh)
  cp -r * "$pkgdir/opt/$pkgname/"
  
  # 3. Ajustar permissões
  chmod -R 777 "$pkgdir/opt/$pkgname"
  chmod +x "$pkgdir/opt/$pkgname/DragonLauncher.sh"
  
  # 4. Criar link simbólico
  ln -sf "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # 5. Instalar o atalho .desktop
  if [ -f "DragonLauncher.desktop" ]; then
    install -m 644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    # Garantir que o Exec aponte para o link simbólico ou para o bash chamando o script
    sed -i "s|Exec=.*|Exec=/usr/bin/dragonlauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  fi
}
