# DragonLauncher
## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O DragonLauncher e uma solucao otimizada para rodar jogos Windows no Arch Linux, traduzindo APIs DirectX para OpenGL/Vulkan. Ideal para hardware limitado ou notebooks com graficos integrados.

---

## Instalacao e Atualizacao

### Primeira Instalação (ou Reinstalação Limpa)
Se você encontrar o erro `fatal: destination path 'DragonLauncher' already exists`, use o comando abaixo para remover a pasta antiga e instalar a nova versão:

```bash
rm -rf DragonLauncher && git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
```

### Atualização Automática (Recomendado)
Abra o DragonLauncher e clique no botão "Verificar Atualizações". O sistema irá automaticamente:
- Verificar se há novas versões disponíveis
- Mostrar as novidades (changelog)
- Baixar e instalar a atualização
- Criar backup da versão anterior

### At### Instalação Manual (Sem makepkg)
Se você não quiser usar o `makepkg`, pode instalar manualmente:
```bash
cd ~/DragonLauncher
sudo ./install.sh
```

### Desinstalação Completa
Para remover o DragonLauncher e todos os seus arquivos do sistema:
```bash
# Via Interface: Clique no botão "Desinstalar DragonLauncher"
# Ou via Terminal:
sudo /opt/dragonlauncher/uninstall.sh
### Atualização Manual via Terminal
```bash
cd ~/DragonLauncher && git pull && makepkg -si --noconfirm
```

Ou execute o script de atualização:
```bash
/opt/dragonlauncher/update.sh
```

---

## 🛠️ Instalação e Remoção Manual (Avançado)

Se você preferir não usar o `makepkg` ou precisar remover tudo manualmente, use os comandos abaixo:

### Instalação Manual
```bash
cd ~/DragonLauncher
sudo ./install.sh
```

### Remoção Completa (Desinstalar)
Para apagar o programa, os atalhos, os logs e todos os arquivos baixados:
```bash
sudo /opt/dragonlauncher/uninstall.sh
```

**O que o desinstalador remove:**
- ✅ O diretório do programa em `/opt/dragonlauncher`
- ✅ O atalho no terminal em `/usr/bin/dragonlauncher`
- ✅ O ícone no menu de aplicativos
- ✅ Todos os logs em `~/.dragonlauncher.log`
- ✅ Backups e arquivos temporários de atualização
- ✅ (Opcional) O prefixo do Wine com seus jogos instalados

### Comando de "Limpeza Total" (Manual)
Se você quiser apagar tudo sem usar o script, execute:
```bash
sudo rm -rf /opt/dragonlauncher
sudo rm -f /usr/bin/dragonlauncher
sudo rm -f /usr/share/applications/dragonlauncher.desktop
rm -rf ~/.dragonlauncher_prefix ~/.dragonlauncher_backup ~/.dragonlauncher.log
```
---

## Como Usar

1.  **Abrir:** Procure por "DragonLauncher" no menu ou digite `dragonlauncher` no terminal.
2.  **Selecionar:** Escolha o arquivo .exe do seu jogo (o explorador abre por padrao na pasta Downloads).
3.  **Configurar:** Escolha o tradutor (Mesa3D + DXVK e o recomendado).
4.  **Jogar:** O launcher cuida de todas as DLLs e configuracoes automaticamente.

---

## Melhorias Recentes
- **Sistema de atualização automática integrado** - Verifica e instala atualizações diretamente do GitHub
- **Verificação de versão em segundo plano** - Notifica quando há novas versões disponíveis
- **Botão de atualização na interface** - Atualização com um clique
- Interface gráfica dedicada em Python/Tkinter
- Explorador de arquivos inicia na pasta Downloads
- Verificação automática de dependências
- Sistema de logs em ~/.dragonlauncher.log
- Instalação automatizada de binários via PKGBUILD

---

## Licenca
Distribuido sob a licenca GPL3. Desenvolvido por DragonSCPOFICIAL.
