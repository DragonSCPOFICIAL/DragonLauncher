# DragonLauncher
## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O DragonLauncher e uma solucao otimizada para rodar jogos Windows no Arch Linux, traduzindo APIs DirectX para OpenGL/Vulkan. Ideal para hardware limitado ou notebooks com graficos integrados.

---

## Instalacao e Atualizacao

### Primeira Instalacao
```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
```

### Atualização Automática (Recomendado)
Abra o DragonLauncher e clique no botão "Verificar Atualizações". O sistema irá automaticamente:
- Verificar se há novas versões disponíveis
- Mostrar as novidades (changelog)
- Baixar e instalar a atualização
- Criar backup da versão anterior

### Atualização Manual via Terminal
```bash
cd ~/DragonLauncher && git pull && makepkg -si --noconfirm
```

Ou execute o script de atualização:
```bash
/opt/dragonlauncher/update.sh
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
