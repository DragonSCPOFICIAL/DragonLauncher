pkgname=dragonlauncher
pkgver=1.0
pkgrel=1
pkgdesc="DragonLauncher: Um emulador de compatibilidade para testar tradutores de jogos (DirectX e OpenGL) no Arch Linux, utilizando Wine."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher-DXGL"
license=('GPL3')
depends=('wine' 'zenity')
source=("$pkgname-$pkgver.zip::https://github.com/DragonSCPOFICIAL/DragonLauncher-DXGL/archive/refs/heads/main.zip")
sha256sums=('SKIP') # Will update after fetching the actual archive

build() {
  cd "$srcdir/$pkgname-$pkgver"
}

package() {
  install -d "$pkgdir/opt/$pkgname"
  cp -r "$srcdir/$pkgname-$pkgver/Testador_DXGL/COMO_USAR.txt" "$pkgdir/opt/$pkgname/"
  cp -r "$srcdir/$pkgname-$pkgver/Testador_DXGL/DragonLauncher.desktop" "$pkgdir/opt/$pkgname/"
  cp -r "$srcdir/$pkgname-$pkgver/Testador_DXGL/DragonLauncher.sh" "$pkgdir/opt/$pkgname/"
  cp -r "$srcdir/$pkgname-$pkgver/Testador_DXGL/comandos.txt" "$pkgdir/opt/$pkgname/"
  cp -r "$srcdir/$pkgname-$pkgver/Testador_DXGL/configs" "$pkgdir/opt/$pkgname/"
  cp -r "$srcdir/$pkgname-$pkgver/Testador_DXGL/prefixo_isolado" "$pkgdir/opt/$pkgname/"
  
  # Criar link simbólico para o executável principal
  install -d "$pkgdir/usr/local/bin"
  ln -s "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/local/bin/dragonlauncher-dxgl"
  
  # Instalar o arquivo .desktop
  install -d "$pkgdir/usr/share/applications"
  install -m644 "$srcdir/$pkgname-$pkgver/Testador_DXGL/DragonLauncher.desktop" "$pkgdir/usr/share/applications/"
  
  # Atualizar o caminho no .desktop para o novo local
  sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/DragonLauncher.desktop"
  sed -i "s|Exec=bash -c \"cd %k && ./DragonLauncher.sh\"|Exec=/usr/local/bin/dragonlauncher-dxgl|" "$pkgdir/usr/share/applications/DragonLauncher.desktop"
}
