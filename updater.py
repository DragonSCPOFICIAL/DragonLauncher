#!/usr/bin/env python3
"""
DragonLauncher Auto-Updater
Verifica e instala atualizações do repositório GitHub automaticamente
"""

import json
import os
import sys
import urllib.request
import urllib.error
import tarfile
import shutil
import subprocess
from pathlib import Path

class DragonUpdater:
    def __init__(self):
        self.base_dir = Path("/opt/dragonlauncher")
        if not self.base_dir.exists():
            self.base_dir = Path(__file__).parent.absolute()
        
        self.version_file = self.base_dir / "version.json"
        self.github_version_url = "https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main/version.json"
        self.temp_dir = Path.home() / ".dragonlauncher_update"
        self.log_file = Path.home() / ".dragonlauncher_update.log"
    
    def log(self, message):
        """Registra mensagens no log e exibe no console"""
        timestamp = subprocess.check_output(['date'], text=True).strip()
        log_msg = f"[{timestamp}] {message}"
        print(log_msg)
        with open(self.log_file, 'a') as f:
            f.write(log_msg + '\n')
    
    def get_current_version(self):
        """Obtém a versão atual instalada"""
        try:
            if self.version_file.exists():
                with open(self.version_file, 'r') as f:
                    data = json.load(f)
                    return data.get('version', '0.0.0'), data.get('build', 0)
            else:
                self.log("Arquivo version.json não encontrado, assumindo versão 1.0.0")
                return "1.0.0", 13
        except Exception as e:
            self.log(f"Erro ao ler versão atual: {e}")
            return "1.0.0", 13
    
    def get_remote_version(self):
        """Obtém a versão disponível no GitHub"""
        try:
            self.log(f"Verificando versão remota em: {self.github_version_url}")
            with urllib.request.urlopen(self.github_version_url, timeout=10) as response:
                data = json.load(response)
                return data.get('version', '0.0.0'), data.get('build', 0), data
        except urllib.error.URLError as e:
            self.log(f"Erro de conexão ao verificar atualização: {e}")
            return None, None, None
        except Exception as e:
            self.log(f"Erro ao obter versão remota: {e}")
            return None, None, None
    
    def compare_versions(self, current_build, remote_build):
        """Compara números de build para determinar se há atualização"""
        return remote_build > current_build
    
    def download_update(self, download_url):
        """Baixa o pacote de atualização"""
        try:
            self.temp_dir.mkdir(parents=True, exist_ok=True)
            download_path = self.temp_dir / "update.tar.gz"
            
            self.log(f"Baixando atualização de: {download_url}")
            
            # Download com barra de progresso
            def report_progress(block_num, block_size, total_size):
                downloaded = block_num * block_size
                percent = min(100, (downloaded / total_size) * 100)
                sys.stdout.write(f"\rProgresso: {percent:.1f}%")
                sys.stdout.flush()
            
            urllib.request.urlretrieve(download_url, download_path, report_progress)
            print()  # Nova linha após o progresso
            
            self.log(f"Download concluído: {download_path}")
            return download_path
        except Exception as e:
            self.log(f"Erro ao baixar atualização: {e}")
            return None
    
    def extract_update(self, archive_path):
        """Extrai o arquivo de atualização"""
        try:
            extract_dir = self.temp_dir / "extracted"
            if extract_dir.exists():
                shutil.rmtree(extract_dir)
            extract_dir.mkdir(parents=True, exist_ok=True)
            
            self.log(f"Extraindo atualização...")
            with tarfile.open(archive_path, 'r:gz') as tar:
                tar.extractall(extract_dir)
            
            self.log(f"Extração concluída: {extract_dir}")
            return extract_dir
        except Exception as e:
            self.log(f"Erro ao extrair atualização: {e}")
            return None
    
    def install_update(self, source_dir):
        """Instala a atualização copiando arquivos"""
        try:
            self.log("Instalando atualização...")
            
            # Criar backup da versão atual
            backup_dir = Path.home() / ".dragonlauncher_backup"
            if backup_dir.exists():
                shutil.rmtree(backup_dir)
            
            self.log("Criando backup da versão atual...")
            shutil.copytree(self.base_dir, backup_dir, symlinks=True)
            
            # Copiar novos arquivos
            self.log("Copiando novos arquivos...")
            for item in source_dir.rglob('*'):
                if item.is_file():
                    relative_path = item.relative_to(source_dir)
                    dest_path = self.base_dir / relative_path
                    
                    # Criar diretório de destino se não existir
                    dest_path.parent.mkdir(parents=True, exist_ok=True)
                    
                    # Copiar arquivo
                    shutil.copy2(item, dest_path)
                    
                    # Manter permissões executáveis
                    if item.suffix in ['.sh', '.py']:
                        os.chmod(dest_path, 0o755)
            
            self.log("Atualização instalada com sucesso!")
            self.log(f"Backup da versão anterior salvo em: {backup_dir}")
            return True
        except Exception as e:
            self.log(f"Erro ao instalar atualização: {e}")
            self.log("Tentando restaurar backup...")
            try:
                if backup_dir.exists():
                    shutil.rmtree(self.base_dir)
                    shutil.copytree(backup_dir, self.base_dir, symlinks=True)
                    self.log("Backup restaurado com sucesso")
            except Exception as restore_error:
                self.log(f"ERRO CRÍTICO ao restaurar backup: {restore_error}")
            return False
    
    def cleanup(self):
        """Remove arquivos temporários"""
        try:
            if self.temp_dir.exists():
                shutil.rmtree(self.temp_dir)
            self.log("Arquivos temporários removidos")
        except Exception as e:
            self.log(f"Erro ao limpar arquivos temporários: {e}")
    
    def check_and_update(self, auto_install=False):
        """Verifica e instala atualizações se disponíveis"""
        self.log("=== DragonLauncher Auto-Updater ===")
        
        # Obter versão atual
        current_version, current_build = self.get_current_version()
        self.log(f"Versão atual: {current_version} (build {current_build})")
        
        # Obter versão remota
        remote_version, remote_build, remote_data = self.get_remote_version()
        
        if remote_version is None:
            self.log("Não foi possível verificar atualizações. Verifique sua conexão com a internet.")
            return False
        
        self.log(f"Versão disponível: {remote_version} (build {remote_build})")
        
        # Comparar versões
        if not self.compare_versions(current_build, remote_build):
            self.log("Você já está usando a versão mais recente!")
            return False
        
        self.log("Nova atualização disponível!")
        self.log("Changelog:")
        for change in remote_data.get('changelog', []):
            self.log(f"  - {change}")
        
        # Perguntar ao usuário se deseja atualizar (se não for automático)
        if not auto_install:
            response = input("\nDeseja instalar a atualização agora? (s/N): ").strip().lower()
            if response not in ['s', 'sim', 'y', 'yes']:
                self.log("Atualização cancelada pelo usuário")
                return False
        
        # Baixar atualização
        download_url = remote_data.get('download_url')
        if not download_url:
            self.log("URL de download não encontrada")
            return False
        
        archive_path = self.download_update(download_url)
        if not archive_path:
            return False
        
        # Extrair atualização
        extract_dir = self.extract_update(archive_path)
        if not extract_dir:
            return False
        
        # Encontrar o diretório DragonLauncher dentro do arquivo extraído
        source_dir = extract_dir / "DragonLauncher"
        if not source_dir.exists():
            # Se não houver subdiretório, usar o próprio diretório extraído
            source_dir = extract_dir
        
        # Instalar atualização
        success = self.install_update(source_dir)
        
        # Limpar arquivos temporários
        self.cleanup()
        
        if success:
            self.log("=== Atualização concluída com sucesso! ===")
            self.log("Reinicie o DragonLauncher para usar a nova versão")
        
        return success

def main():
    """Função principal"""
    updater = DragonUpdater()
    
    # Verificar argumentos de linha de comando
    auto_install = '--auto' in sys.argv or '-a' in sys.argv
    
    try:
        updater.check_and_update(auto_install=auto_install)
    except KeyboardInterrupt:
        print("\n\nAtualização cancelada pelo usuário")
        updater.cleanup()
        sys.exit(1)
    except Exception as e:
        updater.log(f"Erro inesperado: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
