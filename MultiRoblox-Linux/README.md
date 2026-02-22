# MultiRoblox Linux (Sober)

Gerenciador de múltiplas instâncias do Roblox para Linux utilizando o Sober (Flatpak). Este programa permite que você crie perfis isolados para rodar várias contas do Roblox simultaneamente sem conflitos.

## Funcionalidades

- **Múltiplas Instâncias:** Rode quantos Roblox seu hardware aguentar.
- **Isolamento Total:** Cada perfil tem seus próprios dados, login e configurações.
- **Isolamento de Hardware:** Utiliza flags do Flatpak (`--unshare=ipc`, `--socket=pcsc`) para evitar congelamentos entre instâncias.
- **Limpeza de Processos:** Botão dedicado para fechar instâncias travadas no fundo.
- **Interface Simples:** Feito em Python/Tkinter para ser leve e funcional.

## Requisitos

1. **Sober (Flatpak):** O Roblox deve estar instalado via Sober.
2. **Python 3:** Com suporte a Tkinter.
3. **Linux:** Testado principalmente em Arch Linux (mas compatível com outros).

## Como Instalar

1. Abra o seu terminal.
2. Clone o repositório (se ainda não o tiver):
   ```bash
   git clone https://github.com/DragonSCPOFICIAL/DragonLauncher.git
   ```
3. Entre na pasta do MultiRoblox:
   ```bash
   cd DragonLauncher/MultiRoblox-Linux
   ```
4. Dê permissão de execução ao instalador:
   ```bash
   chmod +x instalar_multiroblox.sh
   ```
5. Execute o script de instalação:
   ```bash
   ./instalar_multiroblox.sh
   ```

## Como Atualizar

Se você já tem o programa instalado e quer baixar a versão mais recente com as correções de isolamento:

1. Vá para a pasta raiz do repositório:
   ```bash
   cd ~/DragonLauncher
   ```
2. Baixe as atualizações do GitHub:
   ```bash
   git pull origin master
   ```
3. Entre na pasta do MultiRoblox e rode o instalador novamente:
   ```bash
   cd MultiRoblox-Linux
   ./instalar_multiroblox.sh
   ```

## Como Usar

1. Inicie o programa pelo menu de aplicativos procurando por **"MultiRoblox Linux"** ou digite `multiroblox` no terminal.
2. Clique em **"Novo Perfil"** e dê um nome (ex: Conta1).
3. Selecione o perfil na lista e clique em **"LANÇAR ROBLOX"**.
4. Repita o processo para abrir outras contas.

## Como Desinstalar

Para remover o programa do sistema, basta digitar no terminal:
```bash
multiroblox-uninstall
```
O desinstalador perguntará se você deseja manter ou apagar os dados dos perfis (logins).

---
*Desenvolvido para a comunidade Linux.*
