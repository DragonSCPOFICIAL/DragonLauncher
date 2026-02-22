import os
import subprocess
import tkinter as tk
from tkinter import messagebox, simpledialog
from pathlib import Path
import shutil
import time

# Configurações de diretórios
BASE_DIR = Path.home() / ".local" / "share" / "multiroblox"
PROFILES_DIR = BASE_DIR / "profiles"
SOBER_APP_ID = "org.vinegarhq.Sober"

class MultiRobloxApp:
    def __init__(self, root):
        self.root = root
        self.root.title("MultiRoblox Linux (Sober)")
        self.root.geometry("450x580")
        self.root.configure(bg="#1e1e1e")
        
        # Garantir que os diretórios existam
        PROFILES_DIR.mkdir(parents=True, exist_ok=True)
        
        self.setup_ui()
        self.refresh_profiles()

    def setup_ui(self):
        # Estilo escuro básico
        style = {"bg": "#1e1e1e", "fg": "#ffffff", "font": ("Segoe UI", 10)}
        title_style = {"bg": "#1e1e1e", "fg": "#00a2ff", "font": ("Segoe UI", 16, "bold")}
        
        # Título
        tk.Label(self.root, text="MultiRoblox Manager", **title_style).pack(pady=15)
        
        # Container da lista
        list_frame = tk.Frame(self.root, bg="#1e1e1e")
        list_frame.pack(fill=tk.BOTH, expand=True, padx=25)
        
        tk.Label(list_frame, text="Selecione um perfil:", **style).pack(anchor="w")
        
        self.profile_listbox = tk.Listbox(
            list_frame, 
            bg="#2d2d2d", 
            fg="#ffffff", 
            selectbackground="#00a2ff",
            font=("Segoe UI", 11),
            borderwidth=0,
            highlightthickness=1,
            highlightbackground="#3d3d3d"
        )
        self.profile_listbox.pack(fill=tk.BOTH, expand=True, pady=5)
        
        # Botões
        btn_frame = tk.Frame(self.root, bg="#1e1e1e")
        btn_frame.pack(pady=20)
        
        # Botão Lançar (Destaque)
        tk.Button(
            btn_frame, 
            text="LANÇAR ROBLOX", 
            command=self.launch_profile, 
            bg="#00a2ff", 
            fg="white", 
            font=("Segoe UI", 10, "bold"),
            width=20,
            height=2,
            relief="flat"
        ).grid(row=0, column=0, columnspan=2, pady=10)
        
        # Outros botões
        tk.Button(btn_frame, text="Novo Perfil", command=self.create_profile, width=12, bg="#3d3d3d", fg="white", relief="flat").grid(row=1, column=0, padx=5, pady=5)
        tk.Button(btn_frame, text="Excluir Perfil", command=self.delete_profile, width=12, bg="#f44336", fg="white", relief="flat").grid(row=1, column=1, padx=5, pady=5)
        tk.Button(btn_frame, text="Limpar Travados", command=self.kill_sober_processes, width=26, bg="#ff9800", fg="white", relief="flat").grid(row=2, column=0, columnspan=2, pady=5)
        tk.Button(btn_frame, text="Atualizar Lista", command=self.refresh_profiles, width=26, bg="#3d3d3d", fg="white", relief="flat").grid(row=3, column=0, columnspan=2, pady=5)
        
        tk.Label(self.root, text="Requer Sober (Flatpak) instalado.", bg="#1e1e1e", fg="#888888", font=("Segoe UI", 8, "italic")).pack(pady=10)

    def kill_sober_processes(self, silent=False):
        """Fecha processos do Sober que podem estar travados no fundo"""
        try:
            subprocess.run(["flatpak", "kill", SOBER_APP_ID], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["pkill", "-f", "sober"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["pkill", "-f", "roblox"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if not silent:
                messagebox.showinfo("Limpeza", "Processos do Sober limpos com sucesso!")
        except Exception as e:
            if not silent:
                print(f"Erro ao limpar processos: {e}")

    def refresh_profiles(self):
        self.profile_listbox.delete(0, tk.END)
        if not PROFILES_DIR.exists():
            return
        for profile in sorted(os.listdir(PROFILES_DIR)):
            if (PROFILES_DIR / profile).is_dir():
                self.profile_listbox.insert(tk.END, profile)

    def create_profile(self):
        name = simpledialog.askstring("Novo Perfil", "Digite o nome para o novo perfil (ex: Conta1):")
        if name:
            name = "".join(c for c in name if c.isalnum() or c in (' ', '_')).strip().replace(" ", "_")
            if not name:
                return
            profile_path = PROFILES_DIR / name
            if profile_path.exists():
                messagebox.showerror("Erro", "Este perfil já existe.")
            else:
                profile_path.mkdir(parents=True)
                self.refresh_profiles()
                messagebox.showinfo("Sucesso", f"Perfil '{name}' criado com sucesso!")

    def delete_profile(self):
        selection = self.profile_listbox.curselection()
        if not selection:
            messagebox.showwarning("Aviso", "Selecione um perfil para excluir.")
            return
        
        name = self.profile_listbox.get(selection[0])
        if messagebox.askyesno("Confirmar Exclusão", f"Deseja excluir o perfil '{name}'?\nIsso apagará o login e configurações deste perfil."):
            shutil.rmtree(PROFILES_DIR / name)
            self.refresh_profiles()

    def launch_profile(self):
        selection = self.profile_listbox.curselection()
        if not selection:
            messagebox.showwarning("Aviso", "Selecione um perfil na lista primeiro.")
            return
        
        name = self.profile_listbox.get(selection[0])
        profile_path = PROFILES_DIR / name
        
        self.kill_sober_processes(silent=True)
        time.sleep(0.5)
        
        env = os.environ.copy()
        env["HOME"] = str(profile_path)
        
        try:
            subprocess.Popen(
                ["flatpak", "run", SOBER_APP_ID],
                env=env,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True
            )
            self.root.title(f"Lançando {name}...")
            self.root.after(2000, lambda: self.root.title("MultiRoblox Linux (Sober)"))
        except Exception as e:
            messagebox.showerror("Erro Crítico", f"Não foi possível iniciar o Sober:\n{e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = MultiRobloxApp(root)
    root.mainloop()
