# DragonLauncher 🐉
## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O **DragonLauncher** é uma solução otimizada para rodar jogos Windows no Arch Linux, traduzindo APIs DirectX para OpenGL/Vulkan. Ideal para hardware limitado ou notebooks com gráficos integrados.

---

## 🚀 Instalação e Atualização Inteligente

### 📥 Primeira Instalação
Se você está instalando pela primeira vez, use este comando:
```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
```

### 🔄 Atualizar (Sem deletar nada)
Se você já tem o DragonLauncher e quer apenas baixar as novidades e atualizar o sistema, use este comando de dentro da pasta:
```bash
git pull && makepkg -si
```
*Este comando baixa apenas o que mudou no repositório e reinstala a versão nova, mantendo seus arquivos intactos.*

---

## 🧹 Limpeza Total (Apenas se houver erros graves)
Se algo quebrar e você quiser começar do zero absoluto:
```bash
rm -rf DragonLauncher && git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
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
- ✅ **Atualização Rápida:** Agora suporta `git pull` para atualizações sem reinstalação total.
- ✅ **Erro de Versão:** Corrigido o erro de `pkgver` (agora funciona com ou sem tags Git).
- ✅ **Arquitetura Automática:** Detecta se o jogo é 32 ou 64 bits.
- ✅ **Permissões Inteligentes:** Fallback automático para a pasta do usuário se `/opt` estiver bloqueado.

---

## 📜 Licença
Distribuído sob a licença GPL3. Desenvolvido por DragonSCPOFICIAL.
