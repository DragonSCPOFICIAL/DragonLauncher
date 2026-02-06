#!/usr/bin/env python3
import json
import os
import sys
import urllib.request
import subprocess
import ssl
import shutil
from pathlib import Path

class DragonUpdater:
    def __init__(self):
        # Tentar detectar o diretório de instalação real
        self.base_dir = Path("/opt/dragonlauncher")
        if not self.base_dir.exists():
            # Se não estiver em /opt, usa o diretório onde o script está
            self.base_dir = Path(__file__).parent.absolute()
        
        self.raw_base_url = "https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main"
        self.version_url = f"{self.raw_base_url}/version.json"
        self.log_file = Path.home() / ".dragonlauncher_update.log"
        
        # Configuração de rede robusta
        self.headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'}
        self.context = ssl._create_unverified_context()

    def log(self, msg):
        print(f"[DRAGON-UPDATE] {msg}")
        try:
            with open(self.log_file, "a") as f:
                f.write(f"{msg}\n")
        except:
            pass

    def get_local_version(self):
        try:
            v_path = self.base_dir / "version.json"
            if v_path.exists():
                with open(v_path, "r") as f:
                    return json.load(f).get("build", 0)
        except Exception as e:
            self.log(f"Erro ao ler versão local: {e}")
        return 0

    def get_remote_version(self):
        try:
            self.log(f"Conectando a {self.version_url}...")
            req = urllib.request.Request(self.version_url, headers=self.headers)
            with urllib.request.urlopen(req, context=self.context, timeout=15) as response:
                return json.load(response)
        except Exception as e:
            self.log(f"Erro ao checar versão remota: {e}")
            return None

    def download_file(self, filename):
        url = f"{self.raw_base_url}/{filename}"
        # Usar um arquivo temporário para evitar corromper o original em caso de falha
        dest = self.base_dir / filename
        temp_dest = self.base_dir / f"{filename}.tmp"
        
        try:
            self.log(f"Baixando: {filename}...")
            req = urllib.request.Request(url, headers=self.headers)
            with urllib.request.urlopen(req, context=self.context, timeout=30) as response:
                with open(temp_dest, "wb") as f:
                    f.write(response.read())
            
            # Se baixou com sucesso, substitui o original
            if dest.exists():
                os.remove(dest)
            os.rename(temp_dest, dest)
            os.chmod(dest, 0o755)
            return True
        except Exception as e:
            self.log(f"Falha ao baixar {filename}: {e}")
            if temp_dest.exists():
                os.remove(temp_dest)
            return False

    def run_update(self):
        print("========================================")
        print("   DRAGON LAUNCHER - ATUALIZADOR RAW    ")
        print("========================================")
        
        # Verificar se tem permissão de escrita
        if not os.access(self.base_dir, os.W_OK):
            self.log("ERRO: Sem permissão de escrita em /opt/dragonlauncher.")
            self.log("Por favor, execute com: sudo dragonlauncher")
            return False

        remote_data = self.get_remote_version()
        if not remote_data:
            self.log("ERRO: Falha na conexão com o GitHub.")
            return False

        local_build = self.get_local_version()
        remote_build = remote_data.get("build", 0)
        remote_version = remote_data.get("version", "?.?.?")

        self.log(f"Versão Local: Build {local_build}")
        self.log(f"Versão Remota: {remote_version} (Build {remote_build})")

        if remote_build <= local_build:
            self.log("Você já está na versão mais recente.")
            return True

        self.log("Nova atualização encontrada! Baixando arquivos...")

        # Lista completa de arquivos para sincronizar via RAW
        files_to_update = [
            "interface.py",
            "DragonLauncher.sh",
            "updater.py",
            "uninstall.sh",
            "install.sh",
            "update.sh",
            "version.json",
            "download-bins.sh",
            "DragonLauncher.desktop"
        ]

        success_count = 0
        for file in files_to_update:
            if self.download_file(file):
                success_count += 1
            else:
                self.log(f"Aviso: Falha ao atualizar {file}")

        if success_count >= (len(files_to_update) - 2): # Tolera falha em arquivos não críticos
            self.log("----------------------------------------")
            self.log("SUCESSO: DragonLauncher atualizado!")
            self.log("Reinicie o programa para aplicar.")
            return True
        else:
            self.log("----------------------------------------")
            self.log("ERRO: A atualização falhou em arquivos críticos.")
            return False

if __name__ == "__main__":
    updater = DragonUpdater()
    try:
        if updater.run_update():
            print("\nAtualização finalizada com sucesso.")
            sys.exit(0)
        else:
            print("\nFalha na atualização.")
            sys.exit(1)
    except KeyboardInterrupt:
        print("\nOperação cancelada pelo usuário.")
        sys.exit(1)
    except Exception as e:
        print(f"\nErro inesperado: {e}")
        sys.exit(1)
