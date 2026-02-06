import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import os
import json
import urllib.request
import threading
import subprocess

class DragonLauncherUI:
    def __init__(self, root):
        self.root = root
        self.root.title("DragonLauncher")
        self.root.geometry("550x550")  # Aumentado para caber todos os botões
        self.root.resizable(False, False)
        
        # Configuração de cores para um visual mais limpo
        self.bg_color = "#f5f5f5"
        self.accent_color = "#2c3e50"
        self.root.configure(bg=self.bg_color)
        
        style = ttk.Style()
        style.theme_use('clam')
        style.configure("TFrame", background=self.bg_color)
        style.configure("TLabel", background=self.bg_color, font=('Segoe UI', 10), foreground=self.accent_color)
        style.configure("TButton", padding=8, font=('Segoe UI', 10, 'bold'))
        style.configure("Action.TButton", background=self.accent_color, foreground="white")
        style.map("Action.TButton", background=[('active', '#34495e')])
        
        # Variáveis
        self.game_path = tk.StringVar()
        self.translator = tk.StringVar()
        
        # Layout Principal
        main_frame = ttk.Frame(root, padding="30")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Título
        title_label = ttk.Label(main_frame, text="DragonLauncher", font=('Segoe UI', 22, 'bold'))
        title_label.pack(pady=(0, 20))
        
        # Seleção de Jogo
        ttk.Label(main_frame, text="Selecione o Jogo (.exe):").pack(anchor=tk.W)
        game_frame = ttk.Frame(main_frame)
        game_frame.pack(fill=tk.X, pady=(5, 15))
        
        self.game_entry = ttk.Entry(game_frame, textvariable=self.game_path, font=('Segoe UI', 10))
        self.game_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
        
        ttk.Button(game_frame, text="Procurar", command=self.browse_game).pack(side=tk.RIGHT)
        
        # Seleção de Tradutor
        ttk.Label(main_frame, text="Escolha o Tradutor:").pack(anchor=tk.W)
        
        # Detectar tradutores dinamicamente
        self.translators = self.detect_translators()
        
        self.translator_combo = ttk.Combobox(main_frame, textvariable=self.translator, values=self.translators, state="readonly", font=('Segoe UI', 10))
        self.translator_combo.pack(fill=tk.X, pady=(5, 20))
        if self.translators:
            self.translator_combo.current(0)
        
        # Botão Iniciar
        self.start_button = ttk.Button(main_frame, text="LANÇAR JOGO", style="Action.TButton", command=self.launch)
        self.start_button.pack(fill=tk.X, ipady=5, pady=(10, 0))
        
        # Separador
        ttk.Separator(main_frame, orient='horizontal').pack(fill='x', pady=20)
        
        # Botões de Utilidade
        utils_frame = ttk.Frame(main_frame)
        utils_frame.pack(fill=tk.X)
        
        self.update_button = ttk.Button(utils_frame, text="Verificar Atualizações", command=self.check_updates)
        self.update_button.pack(fill=tk.X, pady=(0, 5))
        
        self.uninstall_button = ttk.Button(utils_frame, text="Desinstalar DragonLauncher", command=self.uninstall_app)
        self.uninstall_button.pack(fill=tk.X, pady=(0, 5))
        
        # Rodapé
        self.footer_label = ttk.Label(main_frame, text="Mantenedor: DragonSCPOFICIAL", font=('Segoe UI', 8), foreground="#7f8c8d")
        self.footer_label.pack(side=tk.BOTTOM, pady=(10, 0))
        
        # Verificar atualizações em segundo plano ao iniciar
        threading.Thread(target=self.silent_update_check, daemon=True).start()

    def detect_translators(self):
        """Detecta tradutores disponíveis nas pastas bin/x32 e bin/x64"""
        base_dir = "/opt/dragonlauncher"
        if not os.path.exists(base_dir):
            base_dir = os.path.dirname(os.path.abspath(__file__))
        
        bin_dir = os.path.join(base_dir, "bin")
        
        # Tradutores padrão
        found_translators = ["Padrao Wine", "Mesa3D + DXVK", "dgVoodoo2"]
        
        if os.path.exists(bin_dir):
            # Procurar por DLLs específicas que indicam tradutores
            # Esta lista pode ser expandida conforme novos tradutores são adicionados
            for arch in ["x32", "x64"]:
                arch_dir = os.path.join(bin_dir, arch)
                if os.path.exists(arch_dir):
                    files = os.listdir(arch_dir)
                    if "d3d11.dll" in files and "dxgi.dll" in files:
                        if "DXVK" not in found_translators: found_translators.append("DXVK")
                    if "opengl32.dll" in files:
                        if "Mesa3D" not in found_translators: found_translators.append("Mesa3D")
                    if "d3d12.dll" in files:
                        if "VKD3D" not in found_translators: found_translators.append("VKD3D")
                    
                    # Adicionar qualquer DLL customizada como opção se não for das padrão
                    for f in files:
                        if f.endswith(".dll") and f.lower() not in ["d3d8.dll", "d3d9.dll", "d3d10.dll", "d3d11.dll", "dxgi.dll", "opengl32.dll"]:
                            name = f.replace(".dll", "")
                            if name not in found_translators:
                                found_translators.append(name)
        
        return sorted(list(set(found_translators)))

    def browse_game(self):
        initial_dir = os.path.expanduser("~/Downloads")
        if not os.path.exists(initial_dir):
            initial_dir = os.path.expanduser("~")
            
        filename = filedialog.askopenfilename(
            initialdir=initial_dir,
            title="Selecionar Jogo",
            filetypes=(("Executaveis Windows", "*.exe"), ("Todos os arquivos", "*.*"))
        )
        if filename:
            self.game_path.set(filename)

    def launch(self):
        game = self.game_path.get()
        translator = self.translator.get()
        
        if not game or not os.path.exists(game):
            messagebox.showerror("Erro", "Por favor, selecione um arquivo .exe valido.")
            return
        
        print(f"GAME_PATH={game}")
        print(f"CHOICE={translator}")
        self.root.destroy()
    
    def get_version_info(self):
        try:
            base_dir = "/opt/dragonlauncher"
            if not os.path.exists(base_dir):
                base_dir = os.path.dirname(os.path.abspath(__file__))
            
            version_file = os.path.join(base_dir, "version.json")
            if os.path.exists(version_file):
                with open(version_file, 'r') as f:
                    return json.load(f)
            return {"version": "1.0.2", "build": 15}
        except:
            return {"version": "1.0.2", "build": 15}
    
    def get_remote_version(self):
        try:
            url = "https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main/version.json"
            with urllib.request.urlopen(url, timeout=5) as response:
                return json.load(response)
        except:
            return None
    
    def silent_update_check(self):
        try:
            local_info = self.get_version_info()
            remote_info = self.get_remote_version()
            
            if remote_info and remote_info.get('build', 0) > local_info.get('build', 0):
                self.root.after(0, lambda: self.footer_label.config(
                    text=f"Nova versão disponível: {remote_info.get('version')} - Clique em 'Verificar Atualizações'",
                    foreground="#e74c3c"
                ))
        except:
            pass
    
    def check_updates(self):
        try:
            local_info = self.get_version_info()
            remote_info = self.get_remote_version()
            
            if not remote_info:
                messagebox.showwarning("Atualização", "Não foi possível verificar atualizações.\nVerifique sua conexão com a internet.")
                return
            
            local_build = local_info.get('build', 0)
            remote_build = remote_info.get('build', 0)
            
            if remote_build <= local_build:
                messagebox.showinfo("Atualização", f"Você já está usando a versão mais recente!\n\nVersão atual: {local_info.get('version')} (build {local_build})")
                return
            
            changelog = "\n".join([f"• {item}" for item in remote_info.get('changelog', [])])
            message = f"Nova versão disponível!\n\nVersão atual: {local_info.get('version')} (build {local_build})\nNova versão: {remote_info.get('version')} (build {remote_build})\n\nNovidades:\n{changelog}\n\nDeseja atualizar agora?"
            
            if messagebox.askyesno("Atualização Disponível", message):
                base_dir = "/opt/dragonlauncher"
                if not os.path.exists(base_dir):
                    base_dir = os.path.dirname(os.path.abspath(__file__))
                
                updater_path = os.path.join(base_dir, "updater.py")
                
                if os.path.exists(updater_path):
                    terminal_cmd = f"x-terminal-emulator -e 'python3 {updater_path} --auto; echo; echo Pressione Enter para fechar...; read'"
                    subprocess.Popen(terminal_cmd, shell=True)
                    messagebox.showinfo("Atualização", "O processo de atualização foi iniciado em uma nova janela.\n\nO DragonLauncher será fechado agora.")
                    self.root.destroy()
                else:
                    messagebox.showerror("Erro", "Script de atualização não encontrado.")
        except Exception as e:
            messagebox.showerror("Erro", f"Erro ao verificar atualizações:\n{str(e)}")
            
    def uninstall_app(self):
        if messagebox.askyesno("Desinstalar", "Tem certeza que deseja remover o DragonLauncher do sistema?\n\nIsso fechará o programa agora."):
            base_dir = "/opt/dragonlauncher"
            if not os.path.exists(base_dir):
                base_dir = os.path.dirname(os.path.abspath(__file__))
            
            uninstall_path = os.path.join(base_dir, "uninstall.sh")
            
            if os.path.exists(uninstall_path):
                terminal_cmd = f"x-terminal-emulator -e 'bash {uninstall_path}; echo; echo Pressione Enter para fechar...; read'"
                subprocess.Popen(terminal_cmd, shell=True)
                self.root.destroy()
            else:
                messagebox.showerror("Erro", "Script de desinstalação não encontrado.")

if __name__ == "__main__":
    root = tk.Tk()
    app = DragonLauncherUI(root)
    root.mainloop()
