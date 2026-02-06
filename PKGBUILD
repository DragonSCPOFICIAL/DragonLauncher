# Maintainer: DragonSCPOFICIAL <dragon@dragonhub.com>
pkgname=dragonlauncher
pkgver=1.0.0
pkgrel=4
pkgdesc="DragonLauncher: Emulador de compatibilidade para jogos Windows no Arch Linux, com tradução DirectX/OpenGL para hardware limitado."
arch=('x86_64')
url="https://github.com/DragonSCPOFICIAL/DragonLauncher"
license=('GPL3')
depends=('wine' 'zenity' 'bash' 'file')
makedepends=('git')
source=("git+https://github.com/DragonSCPOFICIAL/DragonLauncher.git")
sha256sums=('SKIP')

pkgver() {
  cd "DragonLauncher"
  # Tenta descrever a tag, se falhar usa o número de commits, se falhar usa a versão base
  (git describe --long --tags 2>/dev/null || printf "1.0.0.r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)") | sed 's/\([^-]*-g\)/r\1/;s/-/./g'
}

package() {
  cd "$srcdir/DragonLauncher"
  
  # Criar diretórios necessários
  install -d "$pkgdir/opt/$pkgname"
  install -d "$pkgdir/usr/bin"
  install -d "$pkgdir/usr/share/applications"
  
  # Copiar arquivos principais (usando glob para ser flexível com arquivos de documentação)
  install -m755 "DragonLauncher.sh" "$pkgdir/opt/$pkgname/"
  
  # Instalar documentação se existir
  for doc in README.md COMO_USAR.txt comandos.txt; do
    [ -f "$doc" ] && install -m644 "$doc" "$pkgdir/opt/$pkgname/"
  done
  
  # Copiar configurações de forma limpa
  if [ -d "configs" ] && [ "$(ls -A configs)" ]; then
    install -d "$pkgdir/opt/$pkgname/configs"
    cp -r configs/* "$pkgdir/opt/$pkgname/configs/"
  fi
  
  # Copiar arquivos binários
  install -d "$pkgdir/opt/$pkgname/bin/x32"
  install -d "$pkgdir/opt/$pkgname/bin/x64"
  if [ -d "bin" ]; then
    [ -d "bin/x32" ] && cp -r bin/x32/* "$pkgdir/opt/$pkgname/bin/x32/"
    [ -d "bin/x64" ] && cp -r bin/x64/* "$pkgdir/opt/$pkgname/bin/x64/"
    chmod -R 755 "$pkgdir/opt/$pkgname/bin"
  fi
  
  # Criar diretório para prefixo isolado com permissões adequadas
  install -d -m777 "$pkgdir/opt/$pkgname/prefixo_isolado"
  
  # Criar link simbólico para o executável
  ln -sf "/opt/$pkgname/DragonLauncher.sh" "$pkgdir/usr/bin/dragonlauncher"
  
  # Instalar e configurar o arquivo .desktop
  if [ -f "DragonLauncher.desktop" ]; then
    install -m644 "DragonLauncher.desktop" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Exec=.*|Exec=/usr/bin/dragonlauncher|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
    sed -i "s|Path=.*|Path=/opt/$pkgname|" "$pkgdir/usr/share/applications/dragonlauncher.desktop"
  fi
}
