# Guia de Instalação do DragonLauncher no Arch Linux

## Visão Geral

O **DragonLauncher** é um emulador de compatibilidade que permite executar jogos Windows no Arch Linux através da tradução de APIs gráficas (DirectX para OpenGL). Este guia fornece instruções passo a passo para instalar e configurar o DragonLauncher no seu sistema Arch Linux.

## Pré-requisitos

Antes de instalar o DragonLauncher, certifique-se de que você possui os seguintes pacotes instalados no seu Arch Linux:

```bash
sudo pacman -S wine zenity git
```

## Instalação (Método Recomendado - Via PKGBUILD)

Este é o método recomendado para instalar o DragonLauncher como um programa no seu Arch Linux.

### Passo 1: Clonar o Repositório

Abra um terminal e execute:

```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
cd DragonLauncher
```

### Passo 2: Construir e Instalar o Pacote

Use o `makepkg` para construir e instalar o pacote:

```bash
makepkg -si
```

O comando acima irá:
- Instalar as dependências automaticamente (flag `-s`)
- Construir o pacote
- Instalar o DragonLauncher como um programa no seu sistema (flag `-i`)

### Passo 3: Verificar a Instalação

Após a conclusão, o DragonLauncher estará instalado em `/opt/dragonlauncher` e um link simbólico será criado em `/usr/local/bin/dragonlauncher`. Você pode verificar a instalação executando:

```bash
dragonlauncher
```

Se tudo correu bem, uma janela de seleção de arquivo será aberta.

## Como Usar o DragonLauncher

### Iniciando o Launcher

Você pode iniciar o DragonLauncher de duas maneiras:

**Pelo Terminal:**

```bash
dragonlauncher
```

**Pelo Menu de Aplicações:** Procure por "DragonLauncher" no seu menu de aplicações (KDE Plasma, GNOME, etc.) e clique para executá-lo.

### Executando um Jogo

1. Quando o launcher iniciar, uma janela do explorador de arquivos será aberta automaticamente
2. Navegue até o local onde você tem o arquivo executável (.exe) do seu jogo Windows
3. Selecione o arquivo .exe e clique em "Abrir"
4. Uma nova janela aparecerá pedindo que você escolha qual tradutor usar:
   - **Mesa3D + DXVK**: Melhor performance para jogos modernos (utiliza Vulkan/OpenGL)
   - **dgVoodoo2**: Melhor compatibilidade para jogos antigos (DirectX 1-8)
   - **Padrão Wine**: Sem tradutores customizados (apenas teste)
5. Selecione o tradutor desejado e clique em "OK"
6. O jogo será iniciado em um ambiente isolado com as configurações de tradução escolhidas

## Configuração Avançada

### Variáveis de Ambiente

O DragonLauncher utiliza as seguintes variáveis de ambiente para configurar o Wine:

- `WINEPREFIX`: Define o diretório do prefixo Wine isolado (padrão: `/opt/dragonlauncher/prefixo_isolado`)
- `WINEDEBUG`: Controla o nível de debug do Wine (padrão: `-all` para desabilitar debug)
- `WINEDLLOVERRIDES`: Define quais DLLs devem ser carregadas (varia conforme o tradutor escolhido)

### Editar Configurações de Tradutores

As configurações dos tradutores estão localizadas em `/opt/dragonlauncher/configs/`:

- `dgVoodoo.conf`: Configurações do dgVoodoo2
- `dragon.conf`: Configurações personalizadas do DragonLauncher

Você pode editar esses arquivos para ajustar a performance e compatibilidade conforme necessário.

## Solução de Problemas

### Problema: O launcher não abre

**Solução**: Verifique se o `zenity` está instalado:

```bash
sudo pacman -S zenity
```

### Problema: O jogo não inicia

**Solução**: Certifique-se de que o arquivo .exe está acessível e que você tem permissão de leitura. Você também pode tentar executar o jogo com um tradutor diferente.

### Problema: Desempenho ruim

**Solução**: Tente usar o tradutor "Mesa3D + DXVK" para melhor performance. Se o problema persistir, você pode editar as configurações em `/opt/dragonlauncher/configs/` para ajustar as opções de renderização.

### Problema: Erro de permissão

**Solução**: Se você receber erros de permissão, execute:

```bash
sudo chown -R $USER:$USER /opt/dragonlauncher
```

## Desinstalação

Para remover o DragonLauncher do seu sistema:

```bash
sudo pacman -R dragonlauncher
```

Este comando irá remover o programa e todos os seus arquivos do sistema.

## Suporte e Contribuição

Se você encontrar problemas ou tiver sugestões de melhorias, abra uma issue no repositório GitHub do DragonLauncher. Contribuições são bem-vindas!
