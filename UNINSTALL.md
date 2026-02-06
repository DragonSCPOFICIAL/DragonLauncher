# DragonLauncher 🐉 - Manual de Desinstalação

Este manual detalha os passos para desinstalar completamente o DragonLauncher do seu sistema Arch Linux, incluindo a remoção do pacote e de quaisquer arquivos residuais.

## 🗑️ Desinstalação do Pacote

Para remover o pacote `dragonlauncher` do seu sistema, utilize o `pacman` com a opção `-Rns` para remover também as dependências não utilizadas e os arquivos de configuração.

```bash
sudo pacman -Rns dragonlauncher
```

*   **`sudo`**: Executa o comando com privilégios de superusuário.
*   **`pacman -Rns`**: Remove o pacote especificado, suas dependências não utilizadas e os arquivos de configuração.

## 🧹 Remoção de Arquivos Residuais

O DragonLauncher pode criar arquivos e diretórios na sua pasta de usuário para logs e prefixos do Wine. Recomenda-se removê-los para uma desinstalação limpa.

1.  **Remover o arquivo de log:**
    ```bash
    rm -f ~/.dragonlauncher.log
    ```

2.  **Remover o diretório do prefixo isolado (se criado na Home):**
    ```bash
    rm -rf ~/.local/share/dragonlauncher/prefixo
    ```

## 📦 Remoção do Repositório Clonado (Opcional)

Se você clonou o repositório do DragonLauncher para compilar ou inspecionar o código, você pode removê-lo após a desinstalação.

```bash
rm -rf /home/ubuntu/DragonLauncher
```

**Atenção:** Certifique-se de que você está no diretório correto antes de executar este comando para evitar a exclusão acidental de outros arquivos.

Após seguir todos esses passos, o DragonLauncher e seus arquivos associados terão sido completamente removidos do seu sistema.
