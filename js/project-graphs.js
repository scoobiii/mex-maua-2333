// Gráficos Mermaid adicionais para o projeto
const mermaidGraphs = {
    // Organograma do Time de Gestão
    organograma: `
        graph TD
            A[Comitê Diretor do Projeto] --> B(Patrocinador - Prefeitura de Mauá)
            A --> C(Patrocinador - MEX Energia)
            A --> D(Patrocinador - Oliveira & Oliveira)

            B --> E[Gerente de Projeto - Geral]
            C --> E
            D --> E

            E --> F(Gerente - Engenharia e Tecnologia<br/>MEX Energia)
            E --> G(Gerente - Jurídico e Regulatório<br/>Oliveira & Oliveira)
            E --> H(Gerente - Relações Institucionais<br/>Prefeitura de Mauá)
            E --> I(Gerente - Financeiro e Captação)

            F --> F1[Equipe Engenharia]
            F --> F2[Equipe Tecnologia - Datacenter]
            F --> F3[Equipe Sustentabilidade]

            G --> G1[Equipe Jurídica - Contratos]
            G --> G2[Equipe Jurídica - Legislação]

            H --> H1[Equipe Relações Governamentais]
            H --> H2[Equipe Comunicação Social]

            I --> I1[Equipe Modelagem Financeira]
            I --> I2[Equipe Captação Recursos]

            subgraph EPC Company
                J[Diretor de Projeto - EPC] --> K(Gerentes de Construção)
                J --> L(Gerentes de Suprimentos)
                J --> M(Gerentes de Qualidade)
            end

            E --> J

            style A fill:#667eea,stroke:#333,stroke-width:3px,color:#fff
            style F fill:#27ae60,stroke:#333,stroke-width:2px,color:#fff
            style G fill:#e74c3c,stroke:#333,stroke-width:2px,color:#fff
            style H fill:#f39c12,stroke:#333,stroke-width:2px,color:#fff
            style I fill:#9b59b6,stroke:#333,stroke-width:2px,color:#fff
    `,

    // Fluxo de Desenvolvimento da Cripto Mexx
    criptoMexxFlow: `
        graph TD
            A[Definição Conceitual Cripto Mexx] --> B(Análise Viabilidade Técnica e Legal)
            B --> C{Seleção da Blockchain}
            C -->|Ethereum| D1[Desenvolvimento Smart Contract ETH]
            C -->|Polygon| D2[Desenvolvimento Smart Contract MATIC]
            D1 --> E[Auditoria de Segurança]
            D2 --> E
            E --> F[Lançamento do Token]
            F --> G[Integração Plataformas Energia]
            G --> H[Regulamentação e Conformidade]
            H --> I[Operação Comercial]

            subgraph Casos de Uso
                J[Torre Solar] --> K[Gera Energia]
                K --> L[Mint Cripto Mexx]
                L --> M[Negociação no Mercado]
                M --> N[Pagamento Serviços MEX]
            end

            F --> J

            style A fill:#9b59b6,stroke:#333,stroke-width:3px,color:#fff
            style F fill:#27ae60,stroke:#333,stroke-width:2px,color:#fff
            style I fill:#e74c3c,stroke:#333,stroke-width:2px,color:#fff
    `,

    // Cronograma Financeiro
    cronogramaFinanceiro: `
        gantt
            title Cronograma Físico-Financeiro Detalhado
            dateFormat  YYYY-MM-DD
            section Investimentos Fase 1
            Consultoria Inicial     :done, inv1, 2025-01-01, 2025-06-30
            Estudos Viabilidade     :done, inv2, 2025-02-01, 2025-05-31
            section Investimentos Fase 2
            Engenharia Conceitual   :active, inv3, 2025-07-01, 2025-12-31
            Desenvolvimento Cripto  :active, inv4, 2025-08-01, 2025-11-30
            section Investimentos Fase 3
            Engenharia Básica       :inv5, 2026-01-01, 2026-12-31
            Captação US$ 10B        :inv6, 2026-06-01, 2026-12-31
            section Execução
            Contratação EPC         :inv7, 2027-01-01, 2027-06-30
            Construção Complexo     :inv8, 2027-07-01, 2030-12-31
            Operação Comercial      :inv9, 2031-01-01, 2033-12-31
    `,

    // Análise SWOT Visual
    swotAnalysis: `
        quadrantChart
            title Análise SWOT - Projeto Transformacional Mauá
            x-axis Baixo --> Alto
            y-axis Baixo --> Alto
            quadrant-1 Oportunidades
            quadrant-2 Forças
            quadrant-3 Ameaças
            quadrant-4 Fraquezas
            
            Parceria Estratégica: [0.9, 0.9]
            Inovação Tecnológica: [0.9, 0.8]
            Sustentabilidade: [0.8, 0.9]
            Demanda Datacenters: [0.9, 0.7]
            Incentivos Governo: [0.8, 0.8]
            Cidades Inteligentes: [0.7, 0.8]
            
            Complexidade Projeto: [0.2, 0.9]
            Alto Custo Inicial: [0.1, 0.8]
            Aprovações Legislativas: [0.3, 0.6]
            
            Instabilidade Econômica: [0.1, 0.9]
            Concorrência: [0.4, 0.6]
            Avanços Tecnológicos: [0.6, 0.5]
    `,

    // Fluxo de Energia e Sustentabilidade
    energiaFlow: `
        graph LR
            A[Torre Solar] --> B[Vidros Popglass 100% Reciclado]
            B --> C[Filme Fotovoltaico]
            C --> D[Geração Energia Limpa]
            
            D --> E[Datacenter Verticalizado]
            E --> F[Refrigeração Líquida NVIDIA]
            F --> G[Alta Eficiência Energética]
            
            D --> H[Rede Elétrica Local]
            H --> I[Redução Pegada Carbono]
            
            D --> J[Cripto Mexx]
            J --> K[Negociação P2P Energia]
            K --> L[Mercado Energia Tokenizada]
            
            style A fill:#f39c12,stroke:#333,stroke-width:2px,color:#fff
            style D fill:#27ae60,stroke:#333,stroke-width:2px,color:#fff
            style E fill:#e74c3c,stroke:#333,stroke-width:2px,color:#fff
            style J fill:#9b59b6,stroke:#333,stroke-width:2px,color:#fff
    `
};

// Função para renderizar gráficos específicos
function renderMermaidGraph(containerId, graphDefinition) {
    const container = document.getElementById(containerId);
    if (container) {
        container.innerHTML = `<div class="mermaid">${graphDefinition}</div>`;
        mermaid.init(undefined, container.querySelector('.mermaid'));
    }
}

// Função para adicionar gráficos dinâmicos às seções
function addDynamicGraphs() {
    // Adicionar organograma à seção de fases
    const phasesSection = document.getElementById('phases');
    if (phasesSection) {
        const orgChart = document.createElement('div');
        orgChart.className = 'mermaid-container';
        orgChart.innerHTML = `
            <h3>Organograma do Time de Gestão</h3>
            <div class="mermaid">${mermaidGraphs.organograma}</div>
        `;
        phasesSection.appendChild(orgChart);
    }

    // Adicionar fluxo de energia à seção dashboard
    const dashboardSection = document.getElementById('dashboard');
    if (dashboardSection) {
        const energyFlow = document.createElement('div');
        energyFlow.className = 'mermaid-container';
        energyFlow.innerHTML = `
            <h3>Fluxo de Energia e Sustentabilidade</h3>
            <div class="mermaid">${mermaidGraphs.energiaFlow}</div>
        `;
        dashboardSection.appendChild(energyFlow);
    }
}

// Dados para gráficos interativos
const projectData = {
    investmentPhases: [
        { phase: 'FEL I', value: 50, color: '#e74c3c' },
        { phase: 'FEL II', value: 100, color: '#f39c12' },
        { phase: 'FEL III', value: 250, color: '#27ae60' },
        { phase: 'Execução', value: 9600, color: '#3498db' }
    ],
    
    sustainabilityMetrics: [
        { metric: 'Energia Solar (MWh/ano)', target: 5000, current: 0 },
        { metric: 'Redução CO2 (ton/ano)', target: 2500, current: 0 },
        { metric: 'Eficiência Datacenter (PUE)', target: 1.2, current: 0 },
        { metric: 'Reciclagem Materiais (%)', target: 80, current: 0 }
    ],
    
    timeline: [
        { milestone: 'Contrato Parceria', date: '2025-01-01', status: 'completed' },
        { milestone: 'TAP Aprovado', date: '2025-02-15', status: 'completed' },
        { milestone: 'FEL I Concluído', date: '2025-06-30', status: 'in-progress' },
        { milestone: 'FEL II Iniciado', date: '2025-07-01', status: 'planned' },
        { milestone: 'Cripto Mexx Launch', date: '2025-11-30', status: 'planned' },
        { milestone: 'EPC Contratada', date: '2027-06-30', status: 'planned' },
        { milestone: 'Operação Comercial', date: '2031-01-01', status: 'planned' }
    ]
};

// Função para criar gráficos interativos com Chart.js (se disponível)
function createInteractiveCharts() {
    // Esta função pode ser expandida para incluir gráficos mais interativos
    // usando bibliotecas como Chart.js ou D3.js
    console.log('Dados do projeto carregados:', projectData);
}

// Inicialização quando o DOM estiver carregado
document.addEventListener('DOMContentLoaded', function() {
    addDynamicGraphs();
    createInteractiveCharts();
    
    // Re-inicializar Mermaid após adicionar novos gráficos
    setTimeout(() => {
        mermaid.init();
    }, 1000);
});

// Função para exportar dados do projeto
function exportProjectData() {
    const dataToExport = {
        projectInfo: {
            name: 'Projeto Transformacional Mauá',
            investment: 'US$ 10 bilhões',
            duration: '2025-2033',
            partners: ['MEX Energia', 'Oliveira & Oliveira Advogados', 'Prefeitura de Mauá']
        },
        phases: projectData.timeline,
        metrics: projectData.sustainabilityMetrics
    };
    
    const dataStr = JSON.stringify(dataToExport, null, 2);
    const dataBlob = new Blob([dataStr], {type: 'application/json'});
    const url = URL.createObjectURL(dataBlob);
    
    const link = document.createElement('a');
    link.href = url;
    link.download = 'projeto-transformacional-maua-data.json';
    link.click();
    
    URL.revokeObjectURL(url);
}

// Função para integração com dashboard MEX
function integrateMEXDashboard() {
    // Esta função pode ser usada para enviar dados para o dashboard principal
    const integrationData = {
        projectStatus: 'FEL I - Em Andamento',
        energyGeneration: 0, // Será atualizado quando a torre solar estiver operacional
        co2Reduction: 0,
        investmentProgress: 4, // 4% do investimento total (US$ 400M de US$ 10B)
        nextMilestone: 'Conclusão FEL I - Junho 2025'
    };
    
    // Simular envio de dados para o dashboard
    console.log('Dados enviados para Dashboard MEX:', integrationData);
    
    // Em uma implementação real, isso seria uma chamada API
    // fetch('https://api.mex-energia.com/project-update', {
    //     method: 'POST',
    //     headers: { 'Content-Type': 'application/json' },
    //     body: JSON.stringify(integrationData)
    // });
}

// Exportar funções para uso global
window.projectUtils = {
    exportProjectData,
    integrateMEXDashboard,
    renderMermaidGraph,
    projectData
};

