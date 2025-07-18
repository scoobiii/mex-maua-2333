import os

# --- Definição da Estrutura do Projeto ---
# A estrutura agora começa com a pasta 'docs', pois o script
# assume que já está dentro de 'mauax-2333-main'.

PROJECT_STRUCTURE = {
    "docs": {
        "0_PROJETO_DE_LEI_MAUEX": [
            "0.1_PROJETO_DE_LEI_MAUEX_CONSOLIDADO.pdf"
        ],
        "1_FINANCEIRO_E_GOVERNANCA": [
            "1.1_Analise_Viabilidade_Consolidada.pdf",
            "1.2_MAUEX_Bolsa_Tokenomics.pdf",
            "1.3_FSM-MAUEX_Regulamento_Operacional.pdf",
            "1.4_Projecao_Arrecadacao_Tributaria_e_Royalties.pdf",
            "1.5_Mapeamento_Fontes_Financiamento_Green_Bonds.pdf",
            "1.6_Estrutura_Juridica_DAO_e_Governanca.pdf",
            "1.7_Plano_de_Negocios_Bolsa_MAUEX.pdf",
            "1.8_Metodologia_Precificacao_Creditos_Carbono.pdf"
        ],
        "2_TECNICO_ANEXO_I": {
            "Pilar_Energia": [
                "2.1.1_Especificacao_UTE_MEX_TTG_Maua_5GW.pdf",
                "2.1.2_Especificacao_UTE_Termotrig_Pedreira_2.5GW.pdf",
                "2.1.3_Plano_Integracao_Outras_Termicas_7GW.pdf",
                "2.1.4_Estudo_Conexao_Sistema_Interligado_Nacional.pdf",
                "2.1.5_Relatorio_Conformidade_Normas_ISO5000x.pdf"
            ],
            "Pilar_Tecnologia": [
                "2.2.1_Projeto_Datacenter_NVIDIA_TierIV.pdf",
                "2.2.2_Projeto_Sistema_Liquid_Cooling_TIAC.pdf",
                "2.2.3_Projeto_Datacenter_Pedreira_TierIII.pdf",
                "2.2.4_Analise_Tecnica_PUE_Datacenters.pdf",
                "2.2.5_Portfolio_Servicos_AI_e_HPC.pdf"
            ],
            "Pilar_Industria_e_Logistica": [
                "2.3.1_Projeto_Polo_Biomassa_Quimico.pdf",
                "2.3.2_Projeto_Engenharia_Dutos_Etanol_880km.pdf",
                "2.3.3_Estudo_Demanda_Consumo_Etanol_755m3h.pdf",
                "2.3.4_Plano_Interconexao_Malha_Logum.pdf"
            ]
        },
        "3_REGULATORIO_E_IMPACTO": [
            "3.1_Plano_Gestao_Ambiental_ISO14001.pdf",
            "3.2_Estudo_Impacto_Socioeconomico_37k_Empregos.pdf",
            "3.3_Plano_Detalhamento_Contrapartidas_Sociais.pdf",
            "3.4_Estudo_Ciclo_Hidrico_e_Reuso_de_Agua.pdf",
            "3.5_Minuta_Contrato_Parceria_Publico-Privada.pdf",
            "3.6_Estudo_Impacto_Fiscal_e_Incentivos.pdf",
            "3.7_Mapeamento_Areas_Publicas_e_Cessao_de_Uso.pdf"
        ],
        "4_INOVACAO_E_CAPACITACAO": [
            "4.1_Estrutura_Programa_MAUEX_Inteligencia.pdf",
            "4.2_Definicao_Equipe_GOS3_e_Metodologia_Agil.pdf",
            "4.3_Projeto_Pedagogico_Centro_Educacional_SENAI.pdf"
        ],
        "5_ATIVOS_DIGITAIS_E_BLOCKCHAIN": {
            "smart-contracts": [
                "MauaxFoundersNFT.sol"
            ],
            "metadata": [
                # Os 100 arquivos .json serão criados dinamicamente
            ],
            # Arquivos na raiz desta pasta
            "files_in_root": [
                "5.1_Termo_Emissao_Founders_Edition.pdf",
                "5.2_Roteiro_Implantacao_e_Seguranca.pdf"
            ]
        }
    }
}


def create_or_update_structure(base_path, structure):
    """
    Função recursiva para criar as pastas e arquivos definidos no dicionário.
    É segura para ser executada em um diretório existente.
    """
    for name, content in structure.items():
        current_path = os.path.join(base_path, name)

        if isinstance(content, dict):
            # Cria a pasta se ela não existir.
            os.makedirs(current_path, exist_ok=True)
            print(f"✔️  Pasta verificada/criada: {current_path}")

            # Trata o caso especial de arquivos na raiz de uma pasta
            if "files_in_root" in content:
                for filename in content["files_in_root"]:
                    file_path = os.path.join(current_path, filename)
                    if not os.path.exists(file_path):
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(f"# Placeholder para {filename}\n")
                        print(f"  ➕ Arquivo criado: {file_path}")
                del content["files_in_root"]

            create_or_update_structure(current_path, content)

        elif isinstance(content, list):
            for filename in content:
                file_path = os.path.join(base_path, filename)
                # Cria o arquivo placeholder apenas se ele não existir
                if not os.path.exists(file_path):
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(f"# Placeholder para {filename}\n")
                    print(f"  ➕ Arquivo criado: {file_path}")


if __name__ == "__main__":
    # O script usa o diretório atual como ponto de partida (a raiz do projeto)
    base_directory = os.getcwd()

    print("🚀 Iniciando verificação e atualização da estrutura de diretórios...")
    print(f"Diretório base (raiz do projeto): {base_directory}\n")

    create_or_update_structure(base_directory, PROJECT_STRUCTURE)

    # --- Tratamento Especial: Cria os 100 arquivos de metadata, se não existirem ---
    metadata_path = os.path.join(
        base_directory,
        "docs",
        "5_ATIVOS_DIGITAIS_E_BLOCKCHAIN",
        "metadata"
    )
    print(f"\n✨ Verificando/Gerando arquivos de metadata em: {metadata_path}")
    for i in range(1, 101):
        filename = f"{i}.json"
        file_path = os.path.join(metadata_path, filename)
        if not os.path.exists(file_path):
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write('{\n')
                f.write(f'  "name": "MAUEX Founder #{i}",\n')
                f.write(f'  "description": "Token de governança da serie fundadora do ecossistema MAUEX.",\n')
                f.write(f'  "image": "ipfs://YourImageCID/{i}.png"\n')
                f.write('}\n')
            print(f"  ➕ Arquivo criado: {file_path}")

    print("\n✅ Estrutura do projeto verificada e atualizada com sucesso!")