# DragonLauncher
## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O DragonLauncher e uma solucao otimizada para rodar jogos Windows no Arch Linux, traduzindo APIs DirectX para OpenGL/Vulkan. Ideal para hardware limitado ou notebooks com graficos integrados.

---

## Instalacao e Atualizacao

### Primeira Instalacao
```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git && cd DragonLauncher && makepkg -si
```

### Reinstalacao Limpa ou Atualizacao
```bash
cd ~/DragonLauncher && git pull && makepkg -si --noconfirm
```

---

## Como Usar

1.  **Abrir:** Procure por "DragonLauncher" no menu ou digite `dragonlauncher` no terminal.
2.  **Selecionar:** Escolha o arquivo .exe do seu jogo (o explorador abre por padrao na pasta Downloads).
3.  **Configurar:** Escolha o tradutor (Mesa3D + DXVK e o recomendado).
4.  **Jogar:** O launcher cuida de todas as DLLs e configuracoes automaticamente.

---

## Melhorias Recentes
- Interface grafica dedicada em Python/Tkinter.
- Explorador de arquivos inicia na pasta Downloads.
- Verificacao automatica de dependencias.
- Sistema de logs em ~/.dragonlauncher.log.
- Instalacao automatizada de binarios via PKGBUILD.

---

## Licenca
Distribuido sob a licenca GPL3. Desenvolvido por DragonSCPOFICIAL.
