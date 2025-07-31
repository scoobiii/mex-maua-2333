import json
import os

# --- CONFIGURAÇÃO ---
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
DATA_FILE = os.path.join(ROOT_DIR, 'data/tokens_data.json')

def get_token_symbol(token):
    """Função auxiliar para extrair o símbolo do token a partir dos atributos."""
    attributes = token.get('attributes', [])
    
    # Mapeia o 'Tipo' para o Símbolo
    type_to_symbol = {
        "Governança": "MAUAX-G",
        "Utilidade": "MAUAX-C",
        "Energia": "MAUAX-E",
        "Reciclagem": "MAUAX-R",
        "Security Token": "MAUAX-S", # Padrão, pode ser mais específico se necessário
        "Seed Round": "MAUAX-SEED"
    }
    
    for attr in attributes:
        if attr.get('trait_type') == 'Tipo':
            return type_to_symbol.get(attr.get('value'), "UNKNOWN")
    
    # Caso especial para Security Tokens nomeados
    name = token.get('name', '').lower()
    if 'solar' in name: return 'MAUAX-S'
    if 'tower' in name: return 'MAUAX-T'
    if 'bio' in name: return 'MAUAX-B'
    if 'data' in name: return 'MAUAX-D'
    
    return "UNKNOWN"


def update_image_filenames():
    """
    Lê o tokens_data.json, atualiza o campo 'image' de cada token para seguir o
    padrão de nomenclatura oficial, e salva o arquivo de volta.
    """
    try:
        with open(DATA_FILE, 'r+', encoding='utf-8') as f:
            tokens_data = json.load(f)
            print(f"✅ Arquivo '{DATA_FILE}' lido com sucesso. {len(tokens_data)} tokens encontrados.")

            updated_count = 0
            for token in tokens_data:
                token_id = token.get('token_id')
                if not token_id:
                    print(f"  ⚠️ Aviso: Token sem 'token_id' encontrado. Pulando.")
                    continue

                token_symbol = get_token_symbol(token)
                
                # Formata o ID com zeros à esquerda se for numérico
                formatted_id = token_id.zfill(3) if token_id.isdigit() else token_id
                
                new_filename = f"{token_symbol}_{formatted_id}.png"
                new_image_path = f"ipfs://YOUR_IMAGE_CID_HERE/{new_filename}"

                if token.get('image') != new_image_path:
                    token['image'] = new_image_path
                    updated_count += 1
                    print(f"  🔄 Atualizado Token ID {token_id}: novo nome de imagem -> {new_filename}")

            if updated_count > 0:
                # Volta para o início do arquivo para sobrescrevê-lo
                f.seek(0)
                json.dump(tokens_data, f, indent=2, ensure_ascii=False)
                f.truncate()
                print(f"\n✅ {updated_count} tokens foram atualizados. Arquivo '{DATA_FILE}' salvo com sucesso.")
            else:
                print("\n✅ Nenhum token precisou de atualização. Os nomes de arquivo já estão corretos.")

    except FileNotFoundError:
        print(f"❌ ERRO: Arquivo de dados '{DATA_FILE}' não encontrado.")
    except json.JSONDecodeError:
        print(f"❌ ERRO: Arquivo '{DATA_FILE}' contém um JSON inválido.")

if __name__ == "__main__":
    update_image_filenames()
