import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import os
import json
import urllib.request
import threading

class DragonLauncherUI:
    def __init__(self, root):
        self.root = root
        self.root.title("DragonLauncher")
        self.root.geometry("500x400")
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
        self.translator = tk.StringVar(value="Mesa3D + DXVK")
        
        # Layout Principal
        main_frame = ttk.Frame(root, padding="30")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Título (Sem Emojis)
        title_label = ttk.Label(main_frame, text="DragonLauncher", font=('Segoe UI', 20, 'bold'))
        title_label.pack(pady=(0, 30))
        
        # Seleção de Jogo
        ttk.Label(main_frame, text="Selecione o Jogo (.exe):").pack(anchor=tk.W)
        game_frame = ttk.Frame(main_frame)
        game_frame.pack(fill=tk.X, pady=(5, 20))
        
        self.game_entry = ttk.Entry(game_frame, textvariable=self.game_path, font=('Segoe UI', 10))
        self.game_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
        
        ttk.Button(game_frame, text="Procurar", command=self.browse_game).pack(side=tk.RIGHT)
        
        # Seleção de Tradutor
        ttk.Label(main_frame, text="Escolha o Tradutor:").pack(anchor=tk.W)
        translators = ["Mesa3D + DXVK", "dgVoodoo2", "Padrao Wine"]
        self.translator_combo = ttk.Combobox(main_frame, textvariable=self.translator, values=translators, state="readonly", font=('Segoe UI', 10))
        self.translator_combo.pack(fill=tk.X, pady=(5, 30))
        
        # Botão Iniciar
        self.start_button = ttk.Button(main_frame, text="LANCAR JOGO", style="Action.TButton", command=self.launch)
        self.start_button.pack(fill=tk.X, ipady=5)
        
        # Botão de Atualização
        self.update_button = ttk.Button(main_frame, text="Verificar Atualizações", command=self.check_updates)
        self.update_button.pack(fill=tk.X, pady=(10, 0))
        
        # Botão de Desinstalação
        self.uninstall_button = ttk.Button(main_frame, text="Desinstalar DragonLauncher", command=self.uninstall_app)
        self.uninstall_button.pack(fill=tk.X, pady=(5, 0))
        
        # Rodapé
        self.footer_label = ttk.Label(main_frame, text="Mantenedor: DragonSCPOFICIAL", font=('Segoe UI', 8), foreground="#7f8c8d")
        self.footer_label.pack(side=tk.BOTTOM, pady=(10, 0))
        
        # Verificar atualizações em segundo plano ao iniciar
        threading.Thread(target=self.silent_update_check, daemon=True).start()

    def browse_game(self):
        # Define a pasta padrão como Downloads do usuário
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
        
        # Retorna os valores para o script shell via stdout
        print(f"GAME_PATH={game}")
        print(f"CHOICE={translator}")
        self.root.destroy()
    
    def get_version_info(self):
        """Obtém informações de versão local"""
        try:
            base_dir = "/opt/dragonlauncher"
            if not os.path.exists(base_dir):
                base_dir = os.path.dirname(os.path.abspath(__file__))
            
            version_file = os.path.join(base_dir, "version.json")
            if os.path.exists(version_file):
                with open(version_file, 'r') as f:
                    return json.load(f)
            return {"version": "1.0.0", "build": 13}
        except:
            return {"version": "1.0.0", "build": 13}
    
    def get_remote_version(self):
        """Obtém versão disponível no GitHub"""
        try:
            url = "https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main/version.json"
            with urllib.request.urlopen(url, timeout=5) as response:
                return json.load(response)
        except:
            return None
    
    def silent_update_check(self):
        """Verifica atualizações silenciosamente ao iniciar"""
        try:
            local_info = self.get_version_info()
            remote_info = self.get_remote_version()
            
            if remote_info and remote_info.get('build', 0) > local_info.get('build', 0):
                # Atualizar rodapé para indicar atualização disponível
                self.root.after(0, lambda: self.footer_label.config(
                    text=f"Nova versão disponível: {remote_info.get('version')} - Clique em 'Verificar Atualizações'",
                    foreground="#e74c3c"
                ))
        except:
            pass
    
    def check_updates(self):
        """Verifica e instala atualizações"""
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
            
            # Mostrar changelog
            changelog = "\n".join([f"• {item}" for item in remote_info.get('changelog', [])])
            message = f"Nova versão disponível!\n\nVersão atual: {local_info.get('version')} (build {local_build})\nNova versão: {remote_info.get('version')} (build {remote_build})\n\nNovidades:\n{changelog}\n\nDeseja atualizar agora?"
            
            if messagebox.askyesno("Atualização Disponível", message):
                # Executar o updater
                import subprocess
                base_dir = "/opt/dragonlauncher"
                if not os.path.exists(base_dir):
                    base_dir = os.path.dirname(os.path.abspath(__file__))
                
                updater_path = os.path.join(base_dir, "updater.py")
                
                if os.path.exists(updater_path):
                    # Abrir terminal para executar o updater
                    terminal_cmd = f"x-terminal-emulator -e 'python3 {updater_path} --auto; echo; echo Pressione Enter para fechar...; read'"
                    subprocess.Popen(terminal_cmd, shell=True)
                    messagebox.showinfo("Atualização", "O processo de atualização foi iniciado em uma nova janela.\n\nO DragonLauncher será fechado agora.")
                    self.root.destroy()
                else:
                    messagebox.showerror("Erro", "Script de atualização não encontrado.\n\nPor favor, atualize manualmente com:\ncd ~/DragonLauncher && git pull && makepkg -si")
        except Exception as e:
            messagebox.showerror("Erro", f"Erro ao verificar atualizações:\n{str(e)}")
            
    def uninstall_app(self):
        """Chama o script de desinstalação"""
        if messagebox.askyesno("Desinstalar", "Tem certeza que deseja remover o DragonLauncher do sistema?\n\nIsso fechará o programa agora."):
            import subprocess
            base_dir = "/opt/dragonlauncher"
            if not os.path.exists(base_dir):
                base_dir = os.path.dirname(os.path.abspath(__file__))
            
            uninstall_path = os.path.join(base_dir, "uninstall.sh")
            
            if os.path.exists(uninstall_path):
                # Abrir terminal para executar o desinstalador
                terminal_cmd = f"x-terminal-emulator -e 'bash {uninstall_path}; echo; echo Pressione Enter para fechar...; read'"
                subprocess.Popen(terminal_cmd, shell=True)
                self.root.destroy()
            else:
                messagebox.showerror("Erro", "Script de desinstalação não encontrado em:\n" + uninstall_path)

if __name__ == "__main__":
    root = tk.Tk()
    app = DragonLauncherUI(root)
    root.mainloop()
