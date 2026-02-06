# DragonLauncher 🐉
## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O **DragonLauncher** é uma solução otimizada para rodar jogos Windows no Arch Linux, traduzindo APIs DirectX para OpenGL/Vulkan. Ideal para hardware limitado ou notebooks com gráficos integrados.

---

## 🚀 Instalação e Atualização

### 📥 Primeira Instalação
Se você está instalando pela primeira vez:
```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
```

### 🔄 Reinstalação Limpa (Recomendado se houver erros)
Se o programa já está instalado e você quer **remover tudo e reinstalar do zero** a versão mais recente e corrigida:
```bash
sudo pacman -R dragonlauncher --noconfirm; git pull; makepkg -si
```
*Este comando remove a versão antiga do sistema, baixa as correções e instala tudo limpo.*

### ⚡ Atualização Rápida
Se você quer apenas atualizar os arquivos sem desinstalar:
```bash
git pull && makepkg -si
```

---

## 🎮 Como Usar

Após a instalação, o DragonLauncher estará disponível no seu menu de aplicativos ou via terminal:

1.  **Abrir:** Procure por "DragonLauncher" no menu ou digite `dragonlauncher` no terminal.
2.  **Selecionar:** Escolha o arquivo `.exe` do seu jogo.
3.  **Configurar:** Escolha o tradutor (Mesa3D + DXVK é o recomendado para a maioria).
4.  **Jogar:** O launcher cuida de todas as DLLs e configurações de ambiente automaticamente.

---

## 🛠️ O que foi corrigido?
- ✅ **Reinstalação Limpa:** Adicionado comando para remover a versão antiga antes de instalar.
- ✅ **Sistema de Logs:** Agora grava erros em `~/.dragonlauncher.log` para facilitar o diagnóstico.
- ✅ **Erro de Versão:** Corrigido o erro de `pkgver` (agora funciona com ou sem tags Git).
- ✅ **Arquitetura Automática:** Detecta se o jogo é 32 ou 64 bits.

---

## 📜 Licença
Distribuído sob a licença GPL3. Desenvolvido por DragonSCPOFICIAL.
