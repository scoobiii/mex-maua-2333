import os
import shutil

# --- ESTRUTURA DE DESTINO ---
DIRS_TO_CREATE = [
    "contracts",
    "scripts",
    "data",
    "web"
]

# --- MAPEAMENTO DE ARQUIVOS PARA MOVER ---
FILES_TO_MOVE = {
    "docs/5_ATIVOS_DIGITAIS_E_BLOCKCHAIN/smart-contracts/MauaxFoundersNFT.sol": "contracts/MauaxFoundersNFT.sol",
    "docs/5_ATIVOS_DIGITAIS_E_BLOCKCHAIN/smart-contracts/MauaxUtilityToken.sol": "contracts/MauaxUtilityToken.sol",
    "atualize_extrutura.py": "scripts/organize_repository.py", # Move e renomeia o próprio script
    "index.html": "web/index.html",
    "investidores.html": "web/investidores.html",
    "style.css": "web/style.css",
    "script.js": "web/script.js",
    "investidores.js": "web/investidores.js",
    "css": "web/css", # Move a pasta inteira
    "js": "web/js"   # Move a pasta inteira
}

def organize_repo():
    print("🚀 Iniciando a reorganização do repositório para o padrão Web3...")
    base_path = os.getcwd()

    # 1. Criar as pastas de alto nível
    for d in DIRS_TO_CREATE:
        dir_path = os.path.join(base_path, d)
        os.makedirs(dir_path, exist_ok=True)
        print(f"✔️  Pasta verificada/criada: {dir_path}")

    # 2. Mover os arquivos e pastas
    for old_path_str, new_path_str in FILES_TO_MOVE.items():
        old_path = os.path.join(base_path, old_path_str)
        new_path = os.path.join(base_path, new_path_str)
        
        if os.path.exists(old_path):
            try:
                # Garante que o diretório de destino exista
                os.makedirs(os.path.dirname(new_path), exist_ok=True)
                shutil.move(old_path, new_path)
                print(f"  ➡️  Movido: '{old_path_str}' -> '{new_path_str}'")
            except Exception as e:
                print(f"  ❌ Erro ao mover '{old_path_str}': {e}")
        else:
            print(f"  ⚠️  Aviso: Arquivo de origem não encontrado, pulando: '{old_path_str}'")
    
    print("\n✅ Reorganização concluída!")
    print("➡️ Próximo passo: Execute 'git add .', 'git commit', e 'git push' para salvar as mudanças.")

if __name__ == "__main__":
    organize_repo()