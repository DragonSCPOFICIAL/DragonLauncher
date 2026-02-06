import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import sys
import os

class DragonLauncherUI:
    def __init__(self, root):
        self.root = root
        self.root.title("DragonLauncher 🐉")
        self.root.geometry("500x400")
        self.root.resizable(False, False)
        
        # Estilo
        style = ttk.Style()
        style.configure("TButton", padding=6, font=('Helvetica', 10))
        style.configure("TLabel", font=('Helvetica', 10))
        
        # Variáveis
        self.game_path = tk.StringVar()
        self.translator = tk.StringVar(value="Mesa3D + DXVK")
        
        # Layout
        main_frame = ttk.Frame(root, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Título
        title_label = ttk.Label(main_frame, text="DragonLauncher", font=('Helvetica', 18, 'bold'), foreground="#d32f2f")
        title_label.pack(pady=(0, 20))
        
        # Seleção de Jogo
        ttk.Label(main_frame, text="Selecione o Jogo (.exe):").pack(anchor=tk.W)
        game_frame = ttk.Frame(main_frame)
        game_frame.pack(fill=tk.X, pady=(5, 15))
        
        self.game_entry = ttk.Entry(game_frame, textvariable=self.game_path)
        self.game_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 5))
        
        ttk.Button(game_frame, text="Procurar", command=self.browse_game).pack(side=tk.RIGHT)
        
        # Seleção de Tradutor
        ttk.Label(main_frame, text="Escolha o Tradutor:").pack(anchor=tk.W)
        translators = ["Mesa3D + DXVK", "dgVoodoo2", "Padrão Wine"]
        self.translator_combo = ttk.Combobox(main_frame, textvariable=self.translator, values=translators, state="readonly")
        self.translator_combo.pack(fill=tk.X, pady=(5, 20))
        
        # Botão Iniciar
        self.start_button = ttk.Button(main_frame, text="LANÇAR JOGO 🚀", command=self.launch)
        self.start_button.pack(fill=tk.X, ipady=10)
        
        # Rodapé
        ttk.Label(main_frame, text="Mantenedor: DragonSCPOFICIAL", font=('Helvetica', 8), foreground="gray").pack(side=tk.BOTTOM, pady=(10, 0))

    def browse_game(self):
        filename = filedialog.askopenfilename(
            title="Selecionar Jogo",
            filetypes=(("Executáveis Windows", "*.exe"), ("Todos os arquivos", "*.*"))
        )
        if filename:
            self.game_path.set(filename)

    def launch(self):
        game = self.game_path.get()
        translator = self.translator.get()
        
        if not game or not os.path.exists(game):
            messagebox.showerror("Erro", "Por favor, selecione um arquivo .exe válido.")
            return
        
        # Retorna os valores para o script shell via stdout
        print(f"GAME_PATH={game}")
        print(f"CHOICE={translator}")
        self.root.destroy()

if __name__ == "__main__":
    root = tk.Tk()
    app = DragonLauncherUI(root)
    root.mainloop()
