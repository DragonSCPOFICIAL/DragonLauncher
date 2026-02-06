# DragonLauncher

## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O **DragonLauncher** é um emulador de compatibilidade projetado para facilitar a execução e o teste de jogos Windows no Arch Linux. Ele atua como um "tradutor" entre as APIs gráficas do Windows (DirectX) e do Linux (OpenGL), permitindo que jogos que dependem dessas tecnologias funcionem de forma isolada e eficiente. A ferramenta utiliza o Wine e bibliotecas como Mesa3D, DXVK e dgVoodoo2 para garantir a melhor compatibilidade e performance.

### Tradução DirectX/OpenGL para Hardware Limitado

Uma das principais inovações do DragonLauncher é sua capacidade de otimizar a execução de jogos em notebooks e sistemas com placas de vídeo integradas ou mais antigas. Ele realiza a **tradução de chamadas DirectX para OpenGL**, aproveitando o poder de processamento da CPU para compensar as limitações da GPU. Essa estratégia permite que jogos que normalmente não rodariam ou teriam desempenho insatisfatório em hardware menos potente, funcionem de maneira equilibrada e com performance aceitável, estendendo a compatibilidade a uma gama maior de dispositivos.

O DragonLauncher-DXGL é uma ferramenta desenvolvida para facilitar o teste de tradutores gráficos (como DXGL, Mesa3D, e dgVoodoo2) em jogos Windows no ambiente Arch Linux, utilizando o Wine. Ele cria um ambiente isolado, garantindo que as modificações e testes não afetem a instalação principal do seu sistema.

## Funcionalidades

*   **Interface Gráfica Amigável**: Utiliza `zenity` para uma experiência de usuário intuitiva, permitindo a seleção do jogo e do tradutor via janelas gráficas.
*   **Ambiente Isolado**: Cria um `WINEPREFIX` dedicado para cada execução, mantendo seu sistema Arch Linux limpo e sem conflitos.
*   **Seleção de Tradutores**: Permite escolher entre diferentes conjuntos de DLLs de tradução (Mesa3D + DXVK, dgVoodoo2, ou padrão Wine) no momento da execução.
*   **Atalho de Desktop**: Integração com o ambiente de desktop para fácil acesso ao launcher.

## Requisitos

Para utilizar o DragonLauncher-DXGL, você precisará ter os seguintes pacotes instalados no seu Arch Linux:

*   `wine`: Para executar aplicações Windows.
*   `zenity`: Para a interface gráfica do launcher.

Você pode instalá-los via `pacman`:

```bash
sudo pacman -S wine zenity
```

## Instalação (Estilo AUR)

Para instalar o DragonLauncher-DXGL no seu sistema Arch Linux, siga os passos abaixo:

1.  **Clonar o Repositório**:

    ```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher-DXGL.git
cd DragonLauncher-DXGL
    ```

2.  **Construir e Instalar o Pacote**:

    Utilize o `makepkg` para construir o pacote e, em seguida, instale-o com `pacman -U`.

    ```bash
makepkg -si
    ```

    *Nota: Se você encontrar erros de `sha256sums`, edite o `PKGBUILD` e altere `sha256sums=("SKIP")` para `sha256sums=("ANY")` temporariamente, ou atualize o `sha256sums` com o valor correto do arquivo baixado.* 

## Uso

Após a instalação, você pode iniciar o DragonLauncher-DXGL de duas maneiras:

1.  **Pelo Menu de Aplicações**: Procure por "DragonLauncher DXGL" no seu menu de aplicações e clique para executá-lo.
2.  **Pelo Terminal**:

    ```bash
dragonlauncher-dxgl
    ```

Ao iniciar, uma janela gráfica será exibida, permitindo que você:

1.  **Selecione o Jogo (.exe)**: Navegue até o executável do jogo Windows que deseja testar.
2.  **Escolha o Tradutor**: Selecione o tradutor gráfico desejado (Mesa3D + DXVK, dgVoodoo2, ou Padrão Wine).
3.  **Inicie o Jogo**: O jogo será iniciado em um ambiente isolado com as configurações de tradução escolhidas.

## Estrutura do Projeto

*   `PKGBUILD`: Arquivo de construção do pacote para Arch Linux.
*   `DragonLauncher.sh`: O script principal do launcher, responsável pela interface gráfica e execução do Wine.
*   `DragonLauncher.desktop`: Arquivo de atalho para integração com o ambiente de desktop.
*   `COMO_USAR.txt`: Instruções básicas de uso.
*   `bin/`: Contém as DLLs dos tradutores (x32 e x64).
*   `configs/`: Arquivos de configuração para os tradutores.
*   `prefixo_isolado/`: Diretório onde o `WINEPREFIX` isolado é criado.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests no repositório GitHub.

## Licença

Este projeto é licenciado sob a [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
