# DragonLauncher 🐉

## Emulador de Compatibilidade para Jogos Windows no Arch Linux

O **DragonLauncher** é um emulador de compatibilidade projetado para facilitar a execução e o teste de jogos Windows no Arch Linux. Ele atua como um "tradutor" entre as APIs gráficas do Windows (DirectX) e do Linux (OpenGL), permitindo que jogos que dependem dessas tecnologias funcionem de forma isolada e eficiente.

### 🚀 Tradução DirectX/OpenGL para Hardware Limitado

Uma das principais inovações do DragonLauncher é sua capacidade de otimizar a execução de jogos em notebooks e sistemas com placas de vídeo integradas ou mais antigas. Ele realiza a **tradução de chamadas DirectX para OpenGL**, aproveitando o poder de processamento da CPU para compensar as limitações da GPU. Essa estratégia permite que jogos que normalmente não rodariam ou teriam desempenho insatisfatório em hardware menos potente, funcionem de maneira equilibrada e com performance aceitável.

---

## 🛠️ Instalação (Arch Linux)

Para instalar o DragonLauncher, certifique-se de ter o `git`, `wine` e `zenity` instalados.

### Passo Único: Clonar e Instalar
Abra o terminal e execute os comandos abaixo:

```bash
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
cd DragonLauncher
makepkg -si
```

---

## 🔄 Limpeza e Reinstalação (Caso já tenha baixado antes)

Se você já tentou instalar o DragonLauncher anteriormente e encontrou erros, ou se a pasta já existe, use estes comandos para limpar tudo e instalar a versão corrigida do zero:

```bash
rm -rf DragonLauncher
git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
cd DragonLauncher
makepkg -si
```

---

## 🎮 Como Usar

Após a instalação, você pode iniciar o DragonLauncher de duas maneiras:

1.  **Pelo Terminal:** Digite `dragonlauncher`
2.  **Pelo Menu:** Procure por "DragonLauncher" no seu menu de aplicativos.

### Fluxo de Uso:
1.  **Selecionar o Jogo:** Uma janela abrirá para você escolher o arquivo `.exe` do seu jogo.
2.  **Escolher o Tradutor:** Selecione a melhor opção para o seu hardware:
    - **Mesa3D + DXVK**: Melhor performance para jogos modernos.
    - **dgVoodoo2**: Melhor compatibilidade para jogos antigos (DirectX 1-8).
    - **Padrão Wine**: Sem tradutores customizados.
3.  **Jogar:** Clique em "OK" e o jogo iniciará em um ambiente isolado.

---

## 📂 Estrutura do Projeto

*   `DragonLauncher.sh`: Script principal do launcher.
*   `DragonLauncher.desktop`: Atalho para o menu do sistema.
*   `PKGBUILD`: Script de instalação automática.
*   `configs/`: Arquivos de configuração dos tradutores.
*   `bin/`: Bibliotecas de tradução (DLLs) para x32 e x64.

---

## ❌ Desinstalação

Para remover o DragonLauncher do sistema:

```bash
sudo pacman -R dragonlauncher
```

---

## 📜 Licença
Este projeto é licenciado sob a [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
