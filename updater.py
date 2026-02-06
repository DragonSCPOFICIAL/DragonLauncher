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
        self.base_dir = Path("/opt/dragonlauncher")
        if not self.base_dir.exists():
            self.base_dir = Path(__file__).parent.absolute()
        
        self.raw_base_url = "https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main"
        self.version_url = f"{self.raw_base_url}/version.json"
        self.log_file = Path.home() / ".dragonlauncher_update.log"
        
        # Configuração de rede robusta
        self.headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'}
        self.context = ssl._create_unverified_context()

    def log(self, msg):
        print(f"[UPDATER] {msg}")
        with open(self.log_file, "a") as f:
            f.write(f"{msg}\n")

    def get_local_version(self):
        try:
            with open(self.base_dir / "version.json", "r") as f:
                return json.load(f).get("build", 0)
        except:
            return 0

    def get_remote_version(self):
        try:
            req = urllib.request.Request(self.version_url, headers=self.headers)
            with urllib.request.urlopen(req, context=self.context, timeout=10) as response:
                return json.load(response)
        except Exception as e:
            self.log(f"Erro ao checar versão remota: {e}")
            return None

    def download_file(self, filename):
        url = f"{self.raw_base_url}/{filename}"
        dest = self.base_dir / filename
        try:
            self.log(f"Baixando {filename}...")
            req = urllib.request.Request(url, headers=self.headers)
            with urllib.request.urlopen(req, context=self.context, timeout=20) as response:
                with open(dest, "wb") as f:
                    f.write(response.read())
            os.chmod(dest, 0o755)
            return True
        except Exception as e:
            self.log(f"Falha ao baixar {filename}: {e}")
            return False

    def run_update(self):
        self.log("Iniciando verificação de atualização...")
        remote_data = self.get_remote_version()
        if not remote_data:
            self.log("Não foi possível obter dados do servidor.")
            return False

        local_build = self.get_local_version()
        remote_build = remote_data.get("build", 0)

        if remote_build <= local_build:
            self.log(f"Já está na última versão (Build {local_build}).")
            return True

        self.log(f"Nova versão detectada: Build {remote_build}. Atualizando...")

        # Lista de arquivos essenciais para atualizar via RAW
        files_to_update = [
            "interface.py",
            "DragonLauncher.sh",
            "updater.py",
            "uninstall.sh",
            "update.sh",
            "version.json"
        ]

        success_count = 0
        for file in files_to_update:
            if self.download_file(file):
                success_count += 1

        if success_count == len(files_to_update):
            self.log("Atualização concluída com sucesso!")
            return True
        else:
            self.log(f"Atualização parcial: {success_count}/{len(files_to_update)} arquivos baixados.")
            return False

if __name__ == "__main__":
    updater = DragonUpdater()
    if updater.run_update():
        sys.exit(0)
    else:
        sys.exit(1)
