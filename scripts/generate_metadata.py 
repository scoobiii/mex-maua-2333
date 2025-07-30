import json
import os

# --- CONFIGURAÇÃO ---
# Define os caminhos relativos à raiz do projeto para que o script
# possa ser executado de qualquer lugar.
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
DATA_INPUT_FILE = os.path.join(ROOT_DIR, 'data/tokens_data.json')
METADATA_OUTPUT_DIR = os.path.join(ROOT_DIR, 'docs/5_ATIVOS_DIGITAIS_E_BLOCKCHAIN/metadata')

def generate_metadata_files():
    """
    Lê o arquivo JSON mestre ('data/tokens_data.json') e gera os arquivos de metadados
    individuais para cada token na pasta de destino, prontos para o upload no IPFS.
    """
    # Garante que o diretório de saída exista
    os.makedirs(METADATA_OUTPUT_DIR, exist_ok=True)

    try:
        with open(DATA_INPUT_FILE, 'r', encoding='utf-8') as f:
            tokens_data = json.load(f)
    except FileNotFoundError:
        print(f"❌ ERRO: Arquivo de dados '{DATA_INPUT_FILE}' não encontrado. Crie-o primeiro na pasta 'data/'.")
        return
    except json.JSONDecodeError as e:
        print(f"❌ ERRO: Arquivo '{DATA_INPUT_FILE}' contém um JSON inválido. Verifique a sintaxe (ex: vírgulas extras). Erro: {e}")
        return

    print(f"✅ Carregado {len(tokens_data)} tokens de '{DATA_INPUT_FILE}'.")
    print(f"➡️  Gerando arquivos de metadados em '{METADATA_OUTPUT_DIR}'...")

    for token in tokens_data:
        try:
            token_id_str = token['token_id']
            
            # Formata o metadado para o padrão OpenSea/ERC721
            metadata = {
                "name": token.get('name', f"MAUAX Token #{token_id_str}"),
                "description": token.get('description', 'Um ativo digital do ecossistema MAUAX.'),
                "image": f"ipfs://YOUR_IMAGE_CID_HERE/{token_id_str}.png", # Placeholder a ser substituído
                "external_url": f"https://app.mauex.com/token/{token_id_str}",
                "attributes": token.get('attributes', [])
            }
            
            # O nome do arquivo deve ser o ID do token.
            # Para ERC721, o padrão é o número sem zeros à esquerda.
            # Para tokens com IDs não numéricos (como 'SEED001'), mantém o ID como string.
            filename_id = int(token_id_str) if token_id_str.isdigit() else token_id_str
            filename = os.path.join(METADATA_OUTPUT_DIR, f"{filename_id}.json")
            
            with open(filename, 'w', encoding='utf-8') as meta_f:
                json.dump(metadata, meta_f, indent=2, ensure_ascii=False)
            
            # print(f"  📄 Metadados gerados: {os.path.basename(filename)}") # Opcional para menos verbosidade

        except KeyError as e:
            print(f"  ❌ ERRO: O token {token} não possui a chave obrigatória: {e}")
            continue

    print(f"\n✅ Geração de {len(tokens_data)} arquivos de metadados concluída.")
    print("➡️ Próximo passo: Gere as imagens, faça o upload da pasta de imagens para o IPFS (ex: Pinata),")
    print("   e então atualize o placeholder 'YOUR_IMAGE_CID_HERE' nestes arquivos .json.")

if __name__ == "__main__":
    generate_metadata_files()