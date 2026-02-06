# DragonLauncher

## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O **DragonLauncher** é um emulador de compatibilidade projetado para facilitar a execução e o teste de jogos Windows no Arch Linux. Ele atua como um "tradutor" entre as APIs gráficas do Windows (DirectX) e do Linux (OpenGL), permitindo que jogos que dependem dessas tecnologias funcionem de forma isolada e eficiente. A ferramenta utiliza o Wine e bibliotecas como Mesa3D, DXVK e dgVoodoo2 para garantir a melhor compatibilidade e performance.

### Tradução DirectX/OpenGL para Hardware Limitado

Uma das principais inovações do DragonLauncher é sua capacidade de otimizar a execução de jogos em notebooks e sistemas com placas de vídeo integradas ou mais antigas. Ele realiza a **tradução de chamadas DirectX para OpenGL**, aproveitando o poder de processamento da CPU para compensar as limitações da GPU. Essa estratégia permite que jogos que normalmente não rodariam ou teriam desempenho insatisfatório em hardware menos potente, funcionem de maneira equilibrada e com performance aceitável, estendendo a compatibilidade a uma gama maior de dispositivos.

## Funcionalidades

*   **Interface Gráfica Amigável**: Utiliza `zenity` para uma experiência de usuário intuitiva, permitindo a seleção do jogo e do tradutor via janelas gráficas.
*   **Ambiente Isolado**: Cria um `WINEPREFIX` dedicado para cada execução, mantendo seu sistema Arch Linux limpo e sem conflitos.
*   **Seleção de Tradutores**: Permite escolher entre diferentes conjuntos de DLLs de tradução (Mesa3D + DXVK, dgVoodoo2, ou padrão Wine) no momento da execução.
*   **Atalho de Desktop**: Integração com o ambiente de desktop para fácil acesso ao launcher.
*   **Programa Isolado**: O DragonLauncher funciona como um programa independente que não altera o sistema operacional.

## Requisitos

Para utilizar o DragonLauncher, você precisará ter os seguintes pacotes instalados no seu Arch Linux:

```bash
sudo pacman -S wine zenity
```

## Instalação (Estilo AUR)

### Passo 1: Clonar o Repositório

```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
cd DragonLauncher
```

### Passo 2: Construir e Instalar o Pacote

```bash
makepkg -si
```

O comando acima irá:
- Baixar as dependências necessárias
- Construir o pacote
- Instalar o DragonLauncher como um programa no seu sistema Arch Linux

## Como Usar

Após a instalação, você pode iniciar o DragonLauncher de duas maneiras:

### Pelo Terminal

```bash
dragonlauncher
```

### Pelo Menu de Aplicações

Procure por "DragonLauncher DXGL" no seu menu de aplicações (KDE Plasma, GNOME, etc.) e clique para executá-lo.

## Fluxo de Uso

1. **Abrir o Launcher**: Execute `dragonlauncher` ou clique no atalho de desktop
2. **Selecionar o Jogo**: Uma janela do explorador de arquivos será aberta. Navegue até o local onde está o arquivo `.exe` do seu jogo Windows e selecione-o
3. **Escolher o Tradutor**: Uma janela de diálogo aparecerá com as opções de tradutores disponíveis:
   - **Mesa3D + DXVK**: Melhor performance para jogos modernos (utiliza Vulkan/OpenGL)
   - **dgVoodoo2**: Melhor compatibilidade para jogos antigos (DirectX 1-8)
   - **Padrão Wine**: Sem tradutores customizados (apenas teste)
4. **Iniciar o Jogo**: Clique em "OK" e o jogo será iniciado em um ambiente isolado com as configurações de tradução escolhidas

## Estrutura do Projeto

*   `DragonLauncher.sh`: O script principal do launcher, responsável pela interface gráfica e execução do Wine
*   `DragonLauncher.desktop`: Arquivo de atalho para integração com o ambiente de desktop
*   `PKGBUILD`: Arquivo de construção do pacote para Arch Linux
*   `COMO_USAR.txt`: Instruções básicas de uso
*   `configs/`: Arquivos de configuração para os tradutores
*   `prefixo_isolado/`: Diretório onde o `WINEPREFIX` isolado é criado

## Compatibilidade

O DragonLauncher foi desenvolvido especificamente para o **Arch Linux** e é totalmente compatível com:

- Arch Linux (todas as versões recentes)
- KDE Plasma
- GNOME
- Outros ambientes de desktop baseados em X11 ou Wayland

## Desinstalação

Para desinstalar o DragonLauncher:

```bash
sudo pacman -R dragonlauncher
```

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests no repositório GitHub.

## Licença

Este projeto é licenciado sob a [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
