# Guia de Instalação do DragonLauncher no Arch Linux

## Visão Geral

O **DragonLauncher** é um emulador de compatibilidade que permite executar jogos Windows no Arch Linux através da tradução de APIs gráficas (DirectX para OpenGL). Este guia fornece instruções passo a passo para instalar e configurar o DragonLauncher no seu sistema Arch Linux.

## Pré-requisitos

Antes de instalar o DragonLauncher, certifique-se de que você possui os seguintes pacotes instalados no seu Arch Linux:

*   **wine**: Implementação de compatibilidade do Windows para Linux
*   **zenity**: Ferramenta para criar diálogos gráficos em scripts shell
*   **git**: Sistema de controle de versão

Você pode instalá-los usando o `pacman`:

```bash
sudo pacman -S wine zenity git
```

## Método 1: Instalação via PKGBUILD (Recomendado para Arch Linux)

### Passo 1: Clonar o Repositório

Abra um terminal e execute:

```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
cd DragonLauncher
```

### Passo 2: Construir o Pacote

Use o `makepkg` para construir o pacote:

```bash
makepkg -si
```

O comando `-s` instala as dependências automaticamente, e o `-i` instala o pacote após a construção.

### Passo 3: Verificar a Instalação

Após a conclusão, o DragonLauncher estará instalado em `/opt/dragonlauncher` e um link simbólico será criado em `/usr/local/bin/dragonlauncher`. Você pode verificar a instalação executando:

```bash
dragonlauncher
```

## Método 2: Instalação Manual

Se você preferir instalar manualmente sem usar o `makepkg`, siga os passos abaixo:

### Passo 1: Clonar o Repositório

```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
cd DragonLauncher/Testador_DXGL
```

### Passo 2: Criar o Diretório de Instalação

```bash
sudo mkdir -p /opt/dragonlauncher
sudo cp -r . /opt/dragonlauncher/
sudo chown -R $USER:$USER /opt/dragonlauncher
```

### Passo 3: Criar um Link Simbólico

```bash
sudo ln -s /opt/dragonlauncher/DragonLauncher.sh /usr/local/bin/dragonlauncher
sudo chmod +x /usr/local/bin/dragonlauncher
```

### Passo 4: Instalar o Atalho de Desktop

```bash
sudo cp /opt/dragonlauncher/DragonLauncher.desktop /usr/share/applications/
sudo sed -i 's|Path=.*|Path=/opt/dragonlauncher|' /usr/share/applications/DragonLauncher.desktop
sudo sed -i 's|Exec=.*|Exec=/usr/local/bin/dragonlauncher|' /usr/share/applications/DragonLauncher.desktop
```

## Como Usar o DragonLauncher

### Iniciando o Launcher

Após a instalação, você pode iniciar o DragonLauncher de duas maneiras:

1.  **Pelo Terminal**:

    ```bash
    dragonlauncher
    ```

2.  **Pelo Menu de Aplicações**: Procure por "DragonLauncher DXGL" no seu menu de aplicações (KDE Plasma, GNOME, etc.).

### Executando um Jogo

1.  Quando o launcher iniciar, uma janela de seleção de arquivo será aberta.
2.  Navegue até o local onde você tem o arquivo executável (.exe) do seu jogo Windows.
3.  Selecione o arquivo .exe e clique em "Abrir".
4.  Uma nova janela aparecerá pedindo que você escolha qual tradutor usar:
    *   **Mesa3D + DXVK**: Melhor performance para jogos modernos (utiliza Vulkan/OpenGL)
    *   **dgVoodoo2**: Melhor compatibilidade para jogos antigos (DirectX 1-8)
    *   **Padrão Wine**: Sem tradutores customizados (apenas teste)
5.  Selecione o tradutor desejado e clique em "OK".
6.  O jogo será iniciado em um ambiente isolado com as configurações de tradução escolhidas.

## Configuração Avançada

### Variáveis de Ambiente

O DragonLauncher utiliza as seguintes variáveis de ambiente para configurar o Wine:

*   `WINEPREFIX`: Define o diretório do prefixo Wine isolado (padrão: `./prefixo_isolado`)
*   `WINEDEBUG`: Controla o nível de debug do Wine (padrão: `-all` para desabilitar debug)
*   `WINEDLLOVERRIDES`: Define quais DLLs devem ser carregadas (varia conforme o tradutor escolhido)

### Editar Configurações de Tradutores

As configurações dos tradutores estão localizadas em `/opt/dragonlauncher/configs/`:

*   `dgVoodoo.conf`: Configurações do dgVoodoo2
*   `dragon.conf`: Configurações personalizadas do DragonLauncher

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

### Se instalado via PKGBUILD

```bash
sudo pacman -R dragonlauncher
```

### Se instalado manualmente

```bash
sudo rm -rf /opt/dragonlauncher
sudo rm /usr/local/bin/dragonlauncher
sudo rm /usr/share/applications/DragonLauncher.desktop
```

## Suporte e Contribuição

Se você encontrar problemas ou tiver sugestões de melhorias, abra uma issue no repositório GitHub do DragonLauncher. Contribuições são bem-vindas!
