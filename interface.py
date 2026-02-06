import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import os
import json
import urllib.request
import threading
import subprocess
import ssl
import shutil
from pathlib import Path
from PIL import Image, ImageTk

class DragonLauncherUI:
    def __init__(self, root):
        self.root = root
        self.root.title("DragonLauncher - Biblioteca de Jogos")
        self.root.geometry("800x600")
        self.root.configure(bg="#f0f0f0")
        
        # Caminhos
        self.base_dir = "/opt/dragonlauncher"
        if not os.path.exists(self.base_dir):
            self.base_dir = os.path.dirname(os.path.abspath(__file__))
        
        self.config_dir = os.path.expanduser("~/.config/dragonlauncher")
        self.profiles_file = os.path.join(self.config_dir, "profiles.json")
        self.icons_dir = os.path.join(self.config_dir, "icons")
        os.makedirs(self.config_dir, exist_ok=True)
        os.makedirs(self.icons_dir, exist_ok=True)
        
        # Estilo
        self.setup_styles()
        
        # Dados
        self.profiles = self.load_profiles()
        self.translators_32, self.translators_64 = self.detect_translators_by_arch()
        self.image_cache = {} # Cache para imagens do Tkinter
        
        # Layout
        self.setup_ui()
        
        # Verificar atualizações em segundo plano
        threading.Thread(target=self.silent_update_check, daemon=True).start()

    def setup_styles(self):
        style = ttk.Style()
        style.theme_use('clam')
        style.configure("TFrame", background="#f0f0f0")
        style.configure("Sidebar.TFrame", background="#2c3e50")
        style.configure("Card.TFrame", background="white", relief="flat")
        style.configure("TLabel", background="#f0f0f0", font=('Segoe UI', 10))
        style.configure("Title.TLabel", font=('Segoe UI', 18, 'bold'), foreground="#2c3e50")
        style.configure("Sidebar.TButton", padding=10, font=('Segoe UI', 10))
        style.configure("Action.TButton", background="#2c3e50", foreground="white", font=('Segoe UI', 10, 'bold'))

    def setup_ui(self):
        # Container Principal
        self.main_container = ttk.Frame(self.root)
        self.main_container.pack(fill=tk.BOTH, expand=True)
        
        # Sidebar (Esquerda)
        self.sidebar = ttk.Frame(self.main_container, width=200, style="Sidebar.TFrame")
        self.sidebar.pack(side=tk.LEFT, fill=tk.Y)
        self.sidebar.pack_propagate(False)
        
        ttk.Label(self.sidebar, text="DRAGON", font=('Segoe UI', 16, 'bold'), foreground="white", background="#2c3e50").pack(pady=20)
        
        ttk.Button(self.sidebar, text="Biblioteca", command=self.show_library).pack(fill=tk.X, padx=10, pady=5)
        ttk.Button(self.sidebar, text="Adicionar Jogo", command=self.add_game_dialog).pack(fill=tk.X, padx=10, pady=5)
        ttk.Button(self.sidebar, text="Atualizações", command=self.check_updates).pack(fill=tk.X, padx=10, pady=5)
        ttk.Button(self.sidebar, text="Desinstalar", command=self.uninstall_app).pack(fill=tk.X, padx=10, pady=5)
        
        self.footer_info = ttk.Label(self.sidebar, text="v1.2.0", foreground="#bdc3c7", background="#2c3e50", font=('Segoe UI', 8))
        self.footer_info.pack(side=tk.BOTTOM, pady=10)
        
        # Área de Conteúdo (Direita)
        self.content_area = ttk.Frame(self.main_container, padding=20)
        self.content_area.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)
        
        self.show_library()

    def show_library(self):
        # Limpar área de conteúdo
        for widget in self.content_area.winfo_children():
            widget.destroy()
            
        ttk.Label(self.content_area, text="Minha Biblioteca", style="Title.TLabel").pack(anchor=tk.W, pady=(0, 20))
        
        if not self.profiles:
            ttk.Label(self.content_area, text="Nenhum jogo adicionado ainda.\nClique em 'Adicionar Jogo' para começar!", justify=tk.CENTER).pack(expand=True)
            return
            
        # Grid de Jogos
        canvas = tk.Canvas(self.content_area, bg="#f0f0f0", highlightthickness=0)
        scrollbar = ttk.Scrollbar(self.content_area, orient="vertical", command=canvas.yview)
        self.scrollable_frame = ttk.Frame(canvas)
        
        self.scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )
        
        canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
        # Renderizar Cards de Jogos
        row, col = 0, 0
        for game_id, data in self.profiles.items():
            self.create_game_card(self.scrollable_frame, game_id, data, row, col)
            col += 1
            if col > 2:
                col = 0
                row += 1

    def get_game_icon(self, game_id, game_path):
        """Tenta carregar o ícone do jogo ou usa um padrão"""
        icon_path = os.path.join(self.icons_dir, f"{game_id}.png")
        
        # Se não existe ícone extraído, tenta extrair (simulado por enquanto ou usa placeholder)
        if not os.path.exists(icon_path):
            # Aqui poderíamos usar ferramentas como 'wrestool' para extrair ícones reais de .exe
            # Por enquanto, vamos usar um ícone padrão bonito
            pass
            
        try:
            if os.path.exists(icon_path):
                img = Image.open(icon_path)
            else:
                # Placeholder: Um ícone de controle de videogame genérico
                img = Image.new('RGB', (100, 100), color = (44, 62, 80))
            
            img = img.resize((120, 120), Image.Resampling.LANCZOS)
            return ImageTk.PhotoImage(img)
        except:
            return None

    def create_game_card(self, parent, game_id, data, row, col):
        card = tk.Frame(parent, bg="white", padx=10, pady=10, highlightbackground="#ddd", highlightthickness=1)
        card.grid(row=row, column=col, padx=10, pady=10, sticky="nsew")
        
        # Imagem do Jogo
        photo = self.get_game_icon(game_id, data.get('path'))
        if photo:
            self.image_cache[game_id] = photo # Manter referência
            img_label = tk.Label(card, image=photo, bg="white")
            img_label.pack(pady=5)
        
        # Nome do Jogo
        name = data.get('name', 'Jogo Desconhecido')
        tk.Label(card, text=name, font=('Segoe UI', 11, 'bold'), bg="white", wraplength=150).pack(pady=5)
        
        # Tradutor Atual
        translator = data.get('translator', 'Padrao Wine')
        tk.Label(card, text=f"Tradutor: {translator}", font=('Segoe UI', 8), bg="white", fg="#666").pack()
        
        # Botões
        btn_frame = tk.Frame(card, bg="white")
        btn_frame.pack(pady=10)
        
        tk.Button(btn_frame, text="JOGAR", bg="#27ae60", fg="white", font=('Segoe UI', 9, 'bold'), 
                  command=lambda: self.launch_game(game_id), relief="flat", padx=10).pack(side=tk.LEFT, padx=2)
        tk.Button(btn_frame, text="EDITAR", bg="#2980b9", fg="white", font=('Segoe UI', 9), 
                  command=lambda: self.edit_game_dialog(game_id), relief="flat", padx=10).pack(side=tk.LEFT, padx=2)
        tk.Button(btn_frame, text="X", bg="#c0392b", fg="white", font=('Segoe UI', 9), 
                  command=lambda: self.remove_game(game_id), relief="flat", padx=5).pack(side=tk.LEFT, padx=2)

    def add_game_dialog(self, edit_id=None):
        self.game_window = tk.Toplevel(self.root)
        self.game_window.title("Adicionar Novo Jogo" if not edit_id else "Editar Jogo")
        self.game_window.geometry("500x450")
        self.game_window.resizable(False, False)
        self.game_window.transient(self.root)
        self.game_window.grab_set()
        
        frame = ttk.Frame(self.game_window, padding=20)
        frame.pack(fill=tk.BOTH, expand=True)
        
        data = self.profiles.get(edit_id, {}) if edit_id else {}
        
        ttk.Label(frame, text="Nome do Jogo:").pack(anchor=tk.W)
        name_entry = ttk.Entry(frame)
        name_entry.insert(0, data.get('name', ''))
        name_entry.pack(fill=tk.X, pady=(5, 15))
        
        ttk.Label(frame, text="Executável (.exe):").pack(anchor=tk.W)
        path_frame = ttk.Frame(frame)
        path_frame.pack(fill=tk.X, pady=(5, 15))
        path_entry = ttk.Entry(path_frame)
        path_entry.insert(0, data.get('path', ''))
        path_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 5))
        
        def browse():
            initial_dir = os.path.expanduser("~/Downloads")
            if not os.path.exists(initial_dir):
                initial_dir = os.path.expanduser("~")
            f = filedialog.askopenfilename(
                initialdir=initial_dir,
                title="Selecionar Jogo",
                filetypes=[("Executaveis", "*.exe"), ("Todos os arquivos", "*.*")]
            )
            if f:
                path_entry.delete(0, tk.END)
                path_entry.insert(0, f)
                if not name_entry.get():
                    name_entry.insert(0, os.path.basename(f).replace(".exe", ""))
        
        ttk.Button(path_frame, text="...", width=3, command=browse).pack(side=tk.RIGHT)
        
        ttk.Label(frame, text="Categoria do Tradutor:").pack(anchor=tk.W)
        cat_var = tk.StringVar(value=data.get('arch', '64 bits'))
        cat_combo = ttk.Combobox(frame, textvariable=cat_var, values=["32 bits", "64 bits"], state="readonly")
        cat_combo.pack(fill=tk.X, pady=(5, 10))
        
        ttk.Label(frame, text="Escolha o Tradutor:").pack(anchor=tk.W)
        trans_var = tk.StringVar(value=data.get('translator', ''))
        trans_combo = ttk.Combobox(frame, textvariable=trans_var, state="readonly")
        trans_combo.pack(fill=tk.X, pady=(5, 20))
        
        def update_translators(*args):
            if cat_var.get() == "32 bits":
                trans_combo['values'] = self.translators_32
            else:
                trans_combo['values'] = self.translators_64
            if not trans_var.get() and trans_combo['values']: 
                trans_combo.current(0)
            
        cat_var.trace('w', update_translators)
        update_translators()
        
        def save():
            name = name_entry.get()
            path = path_entry.get()
            trans = trans_var.get()
            if name and path and trans:
                game_id = edit_id if edit_id else str(hash(path))
                self.profiles[game_id] = {
                    "name": name,
                    "path": path,
                    "translator": trans,
                    "arch": cat_var.get()
                }
                self.save_profiles()
                self.show_library()
                self.game_window.destroy()
            else:
                messagebox.showwarning("Aviso", "Preencha todos os campos!")
                
        ttk.Button(frame, text="SALVAR JOGO", style="Action.TButton", command=save).pack(fill=tk.X, pady=10)

    def edit_game_dialog(self, game_id):
        self.add_game_dialog(edit_id=game_id)

    def remove_game(self, game_id):
        if messagebox.askyesno("Confirmar", "Remover este jogo da biblioteca?"):
            del self.profiles[game_id]
            self.save_profiles()
            self.show_library()

    def launch_game(self, game_id):
        """Chama o script de inicialização e fecha a interface"""
        data = self.profiles[game_id]
        game_path = data['path']
        translator = data['translator']
        arch = data['arch']
        
        # Chamar o script Bash em um novo processo e fechar a interface
        launcher_script = os.path.join(self.base_dir, "DragonLauncher.sh")
        subprocess.Popen(["bash", launcher_script, "--launch", game_path, translator, arch])
        self.root.destroy()

    def detect_translators_by_arch(self):
        bin_dir = os.path.join(self.base_dir, "bin")
        t32 = ["Padrao Wine"]
        t64 = ["Padrao Wine"]
        
        if os.path.exists(bin_dir):
            for arch, target_list in [("x32", t32), ("x64", t64)]:
                arch_path = os.path.join(bin_dir, arch)
                if os.path.exists(arch_path):
                    files = os.listdir(arch_path)
                    if "d3d11.dll" in files: target_list.append("DXVK")
                    if "opengl32.dll" in files: target_list.append("Mesa3D")
                    if "d3d12.dll" in files: target_list.append("VKD3D")
                    for f in files:
                        if f.endswith(".dll") and f.lower() not in ["d3d8.dll", "d3d9.dll", "d3d10.dll", "d3d11.dll", "dxgi.dll", "opengl32.dll"]:
                            name = f.replace(".dll", "")
                            if name not in target_list: target_list.append(name)
        return sorted(t32), sorted(t64)

    def load_profiles(self):
        if os.path.exists(self.profiles_file):
            try:
                with open(self.profiles_file, 'r') as f:
                    return json.load(f)
            except: return {}
        return {}

    def save_profiles(self):
        with open(self.profiles_file, 'w') as f:
            json.dump(self.profiles, f, indent=4)

    def get_version_info(self):
        try:
            version_file = os.path.join(self.base_dir, "version.json")
            if os.path.exists(version_file):
                with open(version_file, 'r') as f:
                    return json.load(f)
            return {"version": "1.1.6", "build": 23}
        except:
            return {"version": "1.1.6", "build": 23}

    def get_remote_version(self):
        try:
            url = "https://raw.githubusercontent.com/DragonSCPOFICIAL/DragonLauncher/main/version.json"
            headers = {'User-Agent': 'Mozilla/5.0'}
            context = ssl._create_unverified_context()
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=10, context=context) as response:
                return json.load(response)
        except: return None

    def silent_update_check(self):
        remote = self.get_remote_version()
        local = self.get_version_info()
        if remote and remote.get('build', 0) > local.get('build', 0):
            self.root.after(0, lambda: self.footer_info.config(text="Nova versão disponível!", foreground="#e74c3c"))

    def check_updates(self):
        """Verifica e executa a atualização usando o novo sistema Raw 2.0"""
        try:
            local_info = self.get_version_info()
            remote_info = self.get_remote_version()
            
            if not remote_info:
                messagebox.showwarning("Atualização", "Não foi possível conectar ao servidor de atualizações.\nVerifique sua internet.")
                return
            
            local_build = local_info.get('build', 0)
            remote_build = remote_info.get('build', 0)
            
            if remote_build <= local_build:
                messagebox.showinfo("Atualização", f"Você já está na versão mais recente!\nBuild: {local_build}")
                return
            
            changelog = "\n".join([f"• {item}" for item in remote_info.get('changelog', [])])
            if messagebox.askyesno("Nova Versão", f"Build {remote_build} disponível!\n\nNovidades:\n{changelog}\n\nAtualizar agora?"):
                updater_path = os.path.join(self.base_dir, "updater.py")
                terminals = ["x-terminal-emulator", "gnome-terminal", "konsole", "xfce4-terminal", "xterm"]
                cmd_found = False
                for term in terminals:
                    if shutil.which(term):
                        cmd = f"{term} -e 'sudo python3 {updater_path}'"
                        subprocess.Popen(cmd, shell=True)
                        cmd_found = True
                        break
                
                if not cmd_found:
                    subprocess.Popen(f"sudo python3 {updater_path}", shell=True)
                
                self.root.destroy()
        except Exception as e:
            messagebox.showerror("Erro", f"Falha na atualização: {e}")

    def uninstall_app(self):
        """Chama o desinstalador com privilégios sudo"""
        if messagebox.askyesno("Desinstalar", "Deseja remover COMPLETAMENTE o DragonLauncher do sistema?\n\nIsso fechará o programa agora."):
            uninstall_path = os.path.join(self.base_dir, "uninstall.sh")
            terminals = ["x-terminal-emulator", "gnome-terminal", "konsole", "xfce4-terminal", "xterm"]
            cmd_found = False
            for term in terminals:
                if shutil.which(term):
                    cmd = f"{term} -e 'sudo bash {uninstall_path}'"
                    subprocess.Popen(cmd, shell=True)
                    cmd_found = True
                    break
            
            if not cmd_found:
                subprocess.Popen(f"sudo bash {uninstall_path}", shell=True)
                
            self.root.destroy()

if __name__ == "__main__":
    root = tk.Tk()
    app = DragonLauncherUI(root)
    root.mainloop()
