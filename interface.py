import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import os

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
        
        # Rodapé
        ttk.Label(main_frame, text="Mantenedor: DragonSCPOFICIAL", font=('Segoe UI', 8), foreground="#7f8c8d").pack(side=tk.BOTTOM, pady=(10, 0))

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

if __name__ == "__main__":
    root = tk.Tk()
    app = DragonLauncherUI(root)
    root.mainloop()
