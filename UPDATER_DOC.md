# Sistema de Atualização Automática - DragonLauncher

## Visão Geral

O DragonLauncher agora possui um sistema completo de atualização automática que permite aos usuários receberem atualizações diretamente do repositório GitHub sem precisar usar comandos manuais do git ou makepkg.

## Componentes do Sistema

### 1. **version.json**
Arquivo de controle de versão que contém:
- `version`: Versão semântica (ex: "1.0.1")
- `build`: Número sequencial de build
- `release_date`: Data de lançamento
- `update_check_url`: URL para verificar atualizações
- `changelog`: Lista de mudanças na versão
- `download_url`: URL para download do pacote de atualização

### 2. **updater.py**
Script Python responsável por:
- Verificar a versão atual instalada
- Consultar a versão disponível no GitHub
- Comparar versões usando o número de build
- Baixar o pacote de atualização
- Extrair e instalar os novos arquivos
- Criar backup da versão anterior
- Restaurar backup em caso de falha

**Uso:**
```bash
# Verificar e instalar atualizações interativamente
python3 /opt/dragonlauncher/updater.py

# Instalar automaticamente sem confirmação
python3 /opt/dragonlauncher/updater.py --auto
```

### 3. **update.sh**
Script wrapper Bash que:
- Facilita a execução do updater.py
- Verifica dependências
- Fornece fallback para atualização manual via git

**Uso:**
```bash
/opt/dragonlauncher/update.sh
```

### 4. **Interface Gráfica (interface.py)**
A interface foi modificada para incluir:
- **Botão "Verificar Atualizações"**: Permite verificar e instalar atualizações com um clique
- **Verificação em segundo plano**: Ao iniciar, verifica silenciosamente se há atualizações
- **Notificação visual**: Rodapé fica vermelho quando há atualização disponível
- **Diálogo de changelog**: Mostra as novidades antes de atualizar

### 5. **GitHub Actions**
Dois workflows automatizados:

#### a) **release.yml**
Executado quando `version.json` é modificado na branch main:
1. Lê informações de versão
2. Cria arquivo tar.gz com todo o código
3. Cria tag Git (ex: v1.0.1-build14)
4. Publica release no GitHub
5. Anexa o arquivo de atualização ao release

#### b) **test.yml**
Executado em push/PR:
1. Verifica sintaxe Python
2. Verifica sintaxe Bash
3. Valida version.json
4. Verifica permissões de arquivos

## Fluxo de Atualização

### Para o Desenvolvedor:

1. **Fazer alterações no código**
2. **Atualizar version.json**:
   - Incrementar `build`
   - Atualizar `changelog`
   - Atualizar `release_date`
3. **Commit e push para main**:
   ```bash
   git add .
   git commit -m "Versão 1.0.1 - Sistema de atualização"
   git push origin main
   ```
4. **GitHub Actions automaticamente**:
   - Cria o pacote de atualização
   - Publica release
   - Disponibiliza para usuários

### Para o Usuário:

#### Método 1: Interface Gráfica (Recomendado)
1. Abrir DragonLauncher
2. Clicar em "Verificar Atualizações"
3. Ler o changelog
4. Clicar em "Sim" para instalar
5. Aguardar conclusão
6. Reiniciar o DragonLauncher

#### Método 2: Terminal
```bash
/opt/dragonlauncher/update.sh
```

#### Método 3: Manual (Git)
```bash
cd ~/DragonLauncher
git pull
makepkg -si --noconfirm
```

## Estrutura de Diretórios

```
/opt/dragonlauncher/          # Instalação do sistema
├── DragonLauncher.sh         # Script principal
├── interface.py              # Interface gráfica (com botão de atualização)
├── updater.py                # Sistema de atualização
├── update.sh                 # Wrapper de atualização
├── version.json              # Controle de versão
├── download-bins.sh          # Download de binários
├── bin/                      # Binários de tradutores
│   ├── x32/
│   └── x64/
└── configs/                  # Configurações

~/.dragonlauncher_update.log  # Log de atualizações
~/.dragonlauncher_backup/     # Backup da versão anterior
~/.dragonlauncher_update/     # Arquivos temporários (removidos após atualização)
```

## Segurança e Confiabilidade

### Backup Automático
Antes de instalar uma atualização, o sistema:
- Cria backup completo em `~/.dragonlauncher_backup/`
- Preserva permissões e links simbólicos
- Restaura automaticamente em caso de falha

### Verificação de Integridade
- Valida JSON antes de processar
- Verifica conectividade antes de baixar
- Confirma extração antes de instalar

### Logs Detalhados
Todas as operações são registradas em:
- `~/.dragonlauncher_update.log`

### Rollback Automático
Se a instalação falhar:
1. Sistema detecta o erro
2. Remove arquivos parcialmente instalados
3. Restaura backup automaticamente
4. Notifica o usuário

## Versionamento

O sistema usa **número de build** para comparação:
- `build 14` é mais novo que `build 13`
- Versão semântica é apenas informativa
- Build sempre incrementa sequencialmente

## URLs Importantes

- **Verificação de versão**: `https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main/version.json`
- **Download de atualização**: `https://github.com/DragonSCPOFICIAL/DragonLauncher/releases/latest/download/dragonlauncher-update.tar.gz`
- **Releases**: `https://github.com/DragonSCPOFICIAL/DragonLauncher/releases`

## Troubleshooting

### Atualização falhou
1. Verificar log: `cat ~/.dragonlauncher_update.log`
2. Verificar conexão com internet
3. Tentar atualização manual via git

### Backup não restaurou
```bash
# Restaurar manualmente
sudo rm -rf /opt/dragonlauncher
sudo cp -r ~/.dragonlauncher_backup /opt/dragonlauncher
sudo chmod -R 755 /opt/dragonlauncher
```

### Interface não mostra botão de atualização
- Reinstalar usando: `cd ~/DragonLauncher && git pull && makepkg -si`

## Desenvolvimento Futuro

Possíveis melhorias:
- [ ] Verificação de assinatura digital dos pacotes
- [ ] Suporte a canais de atualização (stable/beta)
- [ ] Delta updates (apenas arquivos modificados)
- [ ] Notificações desktop
- [ ] Agendamento de verificações automáticas
- [ ] Interface de rollback para versões anteriores

## Licença

GPL3 - Mesmo que o DragonLauncher principal
