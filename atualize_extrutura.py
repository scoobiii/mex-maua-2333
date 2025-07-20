import os
import shutil

# --- Definição da Estrutura de Destino Final ---
PROJECT_STRUCTURE = {
    "docs": {
        "0_PROTOCOLO_E_ACORDOS": [
            "OFICIO_PROTOCOLO_MAUEX.pdf",
            "ACORDO_COOPERACAO_TECNICA_MAUEX.pdf"
        ],
        "0_PROJETO_DE_LEI_MAUEX": [
            "0.1_PROJETO_DE_LEI_MAUEX_CONSOLIDADO.pdf"
        ],
        "1_FINANCEIRO_E_GOVERNANCA": [
            "1.0_SUMARIO_EXECUTIVO_E_IMPACTO_MAUEX.pdf", # Adicionado
            "1.1_Analise_Viabilidade_Consolidada.pdf",
            "1.2_MAUEX_Bolsa_Tokenomics.pdf",
            "1.3_FSM-MAUEX_Regulamento_Operacional.pdf",
            "1.4_Projecao_Arrecadacao_Tributaria_e_Royalties.pdf",
            "1.5_Mapeamento_Fontes_Financiamento_Green_Bonds.pdf",
            "1.6_Estrutura_Juridica_DAO_e_Governanca.pdf",
            "1.7_Plano_de_Negocios_Bolsa_MAUEX.pdf",
            "1.8_Metodologia_Precificacao_Creditos_Carbono.pdf"
        ],
        # ... (as outras pastas 2, 3, 4, 5 permanecem as mesmas)
    }
}

# --- Definição de Arquivos Antigos para Mover/Renomear ---
FILES_TO_MOVE_AND_RENAME = {
    "docs/0_PROJETO_DE_LEI_MAUEX/OFÍCIO PROTOCOLAR Nº 2023_MAUEX-003.pdf": 
    "docs/0_PROTOCOLO_E_ACORDOS/OFICIO_PROTOCOLO_MAUEX.pdf",
    
    "docs/Governança Solar _Projetos de Lei - Energia Solar e Mercado Livre  __Versão___ 1.0.1 .PDF":
    "docs/_archive/Governança_Solar_old.pdf"
}

# (O resto do script com as funções create_or_update_structure, handle_renames, etc., permanece o mesmo)

def create_or_update_structure(base_path, structure):
    # ... (código da função corrigida)
    pass

def handle_moves_and_renames(base_path, moves):
    print("\n🔄 Verificando arquivos para mover e renomear...")
    for old_path_str, new_path_str in moves.items():
        old_path = os.path.join(base_path, *old_path_str.split('/'))
        new_path = os.path.join(base_path, *new_path_str.split('/'))
        
        # Garante que o diretório de destino exista
        os.makedirs(os.path.dirname(new_path), exist_ok=True)

        if os.path.exists(old_path) and not os.path.exists(new_path):
            try:
                shutil.move(old_path, new_path)
                print(f"  ✅ Movido/Renomeado: '{old_path_str}' -> '{new_path_str}'")
            except OSError as e:
                print(f"  ❌ Erro ao mover '{old_path}': {e}")

if __name__ == "__main__":
    base_directory = os.getcwd()
    print("🚀 Iniciando ATUALIZAÇÃO E LIMPEZA da estrutura de diretórios...")
    
    # Passo 1: Mover e renomear arquivos existentes para a nova estrutura
    handle_moves_and_renames(base_directory, FILES_TO_MOVE_AND_RENAME)
    
    # Passo 2: Criar as pastas e arquivos placeholder que estiverem faltando
    # (O dicionário PROJECT_STRUCTURE deve ser completo aqui)
    # create_or_update_structure(base_directory, PROJECT_STRUCTURE)
    
    print("\n✅ Processo de atualização concluído!")
