# DragonLauncher 🐉
## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O **DragonLauncher** é uma solução otimizada para rodar jogos Windows no Arch Linux, traduzindo APIs DirectX para OpenGL/Vulkan. Ideal para hardware limitado ou notebooks com gráficos integrados.

---

## 🚀 Instalação Super Fácil (Recomendado)

Para instalar tudo automaticamente e já configurado, abra seu terminal e **copie e cole** o comando abaixo:

```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
```

> **O que este comando faz?**
> 1. Baixa a versão mais recente e corrigida.
> 2. Entra na pasta do projeto.
> 3. Compila e instala o launcher com todas as dependências necessárias.

---

## 🔄 Limpeza e Reinstalação
Se você teve erros em instalações anteriores, use este comando para limpar tudo e reinstalar a versão corrigida:

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
- ✅ **Erro de Diretório:** Corrigido o erro "No such file or directory" no instalador.
- ✅ **Arquitetura Automática:** Agora detecta se o jogo é 32 ou 64 bits e carrega as DLLs certas.
- ✅ **Permissões Inteligentes:** Se o sistema bloquear a pasta `/opt`, ele cria um prefixo seguro na sua pasta pessoal.
- ✅ **Dependências:** Verifica automaticamente se você tem `wine`, `zenity` e `file` instalados.

---

## 📜 Licença
Distribuído sob a licença GPL3. Desenvolvido por DragonSCPOFICIAL.
