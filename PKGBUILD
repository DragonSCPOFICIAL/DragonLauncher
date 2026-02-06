# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=3
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux, com tradução DirectX/OpenGL para hardware limitado."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'zenity' 'bash')
makedepends=('git')
source=("git+https://github.com/DragonSCPOFICIAL/DragonLauncher.git")
sha256sums=('SKIP')

pkgver() {
  # Entrar no diretório clonado (o nome do diretório criado pelo git é o nome do repo)
  cd "DragonLauncher"
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g' || echo "1.0.0"
}

build() {
  # No build step needed for this script-based launcher
  true
}

package() {
  # O makepkg extrai o git no diretório DragonLauncher dentro do srcdir
  cd "$srcdir/DragonLauncher"
  
  # Criar diretório de instalação
  install -d "$pkgdir/opt/$pkgname"
  
  # Copiar os arquivos principais
  install -m755 "DragonLauncher.sh" "$pkgdir/opt/$pkgname/"
  install -m644 "DragonLauncher.desktop" "$pkgdir/opt/$pkgname/"
  [ -f "COMO_USAR.txt" ] && install -m644 "COMO_USAR.txt" "$pkgdir/opt/$pkgname/"
  [ -f "comandos.txt" ] && install -m644 "comandos.txt" "$pkgdir/opt/$pkgname/"
  [ -f "README.md" ] && install -m644 "README.md" "$pkgdir/opt/$pkgname/"
  
  # Copiar configurações
  install -d "$pkgdir/opt/$pkgname/configs"
  if [ -d "configs" ] && [ "$(ls -A configs)" ]; then
    cp -r configs/* "$pkgdir/opt/$pkgname/configs/"
  fi
  
  # Copiar arquivos binários
  if [ -d "bin" ] && [ "$(ls -A bin)" ]; then
    cp -r "bin" "$pkgdir/opt/$pkgname/"
    chmod -R 755 "$pkgdir/opt/$pkgname/bin"
  else
    # Garantir que os diretórios existam mesmo se vazios
    install -d "$pkgdir/opt/$pkgname/bin/x32"
    install -d "$pkgdir/opt/$pkgname/bin/x64"
  fi
  
  # Criar diretório para prefixo isolado (com permissão de escrita para o usuário)
  install -d -m777 "$pkgdir/opt/$pkgname/prefixo_isolado"
  
  # Criar link simbólico para o executável principal
  install -d "$pkgdir/usr/bin"
  ln -s "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # Instalar o arquivo .desktop
  install -d "$pkgdir/usr/share/applications"
  install -m644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  
  # Ajustar caminhos no .desktop para o local correto de instalação
  sed -i "s|Exec=.*|Exec=/usr/bin/dragonlauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
}
