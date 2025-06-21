# Documentação de Instalação e Uso - Site Projeto Transformacional Mauá

## 📋 Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Instalação Local](#instalação-local)
3. [Configuração do Ambiente](#configuração-do-ambiente)
4. [Execução Local](#execução-local)
5. [Deploy via Git Pages](#deploy-via-git-pages)
6. [Estrutura de Arquivos](#estrutura-de-arquivos)
7. [Uso e Navegação](#uso-e-navegação)
8. [Personalização](#personalização)
9. [Manutenção](#manutenção)
10. [Solução de Problemas](#solução-de-problemas)

## 🔧 Pré-requisitos

### Requisitos Mínimos do Sistema
- **Sistema Operacional**: Windows 10+, macOS 10.14+, ou Linux (Ubuntu 18.04+)
- **Navegador**: Chrome 80+, Firefox 75+, Safari 13+, ou Edge 80+
- **Python**: 3.6+ (para servidor local)
- **Git**: 2.20+ (para versionamento)
- **Conexão com Internet**: Para CDNs e recursos externos

### Dependências Externas
- **Mermaid.js**: v10.6.1+ (carregado via CDN)
- **Fontes**: Segoe UI, Tahoma, Geneva, Verdana, sans-serif
- **Ícones**: Unicode/Emoji (nativo do navegador)

## 🚀 Instalação Local

### Método 1: Download Direto

1. **Baixe os arquivos do projeto**:
   ```bash
   # Se você tem acesso ao repositório
   git clone https://github.com/[usuario]/mex-project-site.git
   cd mex-project-site
   ```

2. **Ou crie a estrutura manualmente**:
   ```bash
   mkdir mex-project-site
   cd mex-project-site
   mkdir css js docs
   ```

### Método 2: Cópia dos Arquivos

1. **Copie os arquivos principais**:
   - `index.html` (página principal)
   - `css/dynamic-styles.css` (estilos adicionais)
   - `js/project-graphs.js` (funcionalidades JavaScript)
   - `README.md` (documentação)

## ⚙️ Configuração do Ambiente

### Estrutura de Diretórios
```
mex-project-site/
├── index.html                 # Página principal
├── README.md                  # Documentação principal
├── INSTALL.md                 # Este arquivo
├── css/
│   └── dynamic-styles.css     # Estilos CSS adicionais
├── js/
│   └── project-graphs.js      # Scripts JavaScript
├── docs/                      # Documentos do projeto
│   ├── tap.pdf
│   ├── contrato-parceria.pdf
│   ├── cronograma.pdf
│   └── cripto-mexx.pdf
├── assets/                    # Recursos estáticos
│   ├── images/
│   └── icons/
└── .gitignore                 # Arquivos ignorados pelo Git
```

### Configuração de Permissões (Linux/macOS)
```bash
# Dar permissões de execução se necessário
chmod +x *.sh
chmod 644 *.html *.css *.js *.md
```

## 🖥️ Execução Local

### Método 1: Servidor Python (Recomendado)
```bash
# Navegue até o diretório do projeto
cd mex-project-site

# Inicie o servidor local na porta 8080
python3 -m http.server 8080

# Ou na porta 3000
python3 -m http.server 3000
```

### Método 2: Servidor Node.js
```bash
# Instale o http-server globalmente
npm install -g http-server

# Inicie o servidor
http-server -p 8080 -c-1
```

### Método 3: Live Server (VS Code)
1. Instale a extensão "Live Server" no VS Code
2. Clique com botão direito em `index.html`
3. Selecione "Open with Live Server"

### Método 4: Servidor PHP
```bash
# Se você tem PHP instalado
php -S localhost:8080
```

## 🌐 Deploy via Git Pages

### GitHub Pages

1. **Crie um repositório no GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit - Projeto Transformacional Mauá"
   git branch -M main
   git remote add origin https://github.com/[usuario]/mex-project-site.git
   git push -u origin main
   ```

2. **Configure GitHub Pages**:
   - Vá para Settings → Pages
   - Source: Deploy from a branch
   - Branch: main / (root)
   - Clique em "Save"

3. **Acesse o site**:
   - URL: `https://[usuario].github.io/mex-project-site/`

### GitLab Pages

1. **Crie arquivo `.gitlab-ci.yml`**:
   ```yaml
   pages:
     stage: deploy
     script:
       - mkdir public
       - cp -r * public/
     artifacts:
       paths:
         - public
     only:
       - main
   ```

2. **Faça push para GitLab**:
   ```bash
   git add .gitlab-ci.yml
   git commit -m "Add GitLab Pages configuration"
   git push
   ```

## 📁 Estrutura de Arquivos Detalhada

### `index.html`
- **Função**: Página principal do site
- **Dependências**: Mermaid.js (CDN), CSS interno
- **Seções**: Header, Navigation, Content Sections, Scripts

### `css/dynamic-styles.css`
- **Função**: Estilos adicionais e animações
- **Recursos**: Animações CSS, responsividade, temas
- **Compatibilidade**: CSS3, Flexbox, Grid

### `js/project-graphs.js`
- **Função**: Gráficos Mermaid e interatividade
- **Dependências**: Mermaid.js
- **Funcionalidades**: Gráficos dinâmicos, exportação de dados

## 🎯 Uso e Navegação

### Interface Principal

1. **Header**:
   - Título do projeto
   - Subtítulo com período
   - Informações de parceria

2. **Navegação por Abas**:
   - **Visão Geral**: Estatísticas e diagrama principal
   - **Fases do Projeto**: Cronograma e entregas
   - **Entregáveis**: Responsabilidades por fase
   - **Cripto Mexx**: Conceito e tecnologia
   - **Dashboard**: Integração com MEX Energia

### Funcionalidades Interativas

#### Gráficos Mermaid
- **Visualização**: Automática ao carregar a página
- **Interação**: Hover para detalhes
- **Responsividade**: Adaptação automática ao tamanho da tela

#### Navegação por Seções
```javascript
// Trocar de seção
function showSection(sectionId) {
    // Remove classe active de todas as seções
    // Adiciona classe active na seção selecionada
    // Atualiza tab ativa
}
```

#### Exportação de Dados
```javascript
// Exportar dados do projeto
window.projectUtils.exportProjectData();
```

### Atalhos de Teclado
- **Tab**: Navegar entre elementos
- **Enter/Space**: Ativar botões
- **Esc**: Fechar modais (se implementados)

## 🎨 Personalização

### Alteração de Cores
```css
/* Variáveis CSS principais */
:root {
    --primary-color: #667eea;
    --secondary-color: #764ba2;
    --success-color: #27ae60;
    --warning-color: #f39c12;
    --danger-color: #e74c3c;
}
```

### Modificação de Gráficos Mermaid
```javascript
// Em js/project-graphs.js
const mermaidGraphs = {
    // Adicione novos gráficos aqui
    novoGrafico: `
        graph TD
            A[Novo Elemento] --> B[Outro Elemento]
    `
};
```

### Adição de Novas Seções
1. **HTML**: Adicione nova div com classe `content-section`
2. **CSS**: Estilize conforme necessário
3. **JavaScript**: Adicione botão de navegação

### Configuração do Mermaid
```javascript
mermaid.initialize({ 
    startOnLoad: true,
    theme: 'default', // ou 'dark', 'forest', 'neutral'
    themeVariables: {
        primaryColor: '#667eea',
        primaryTextColor: '#333',
        primaryBorderColor: '#764ba2'
    }
});
```

## 🔧 Manutenção

### Atualizações Regulares

1. **Conteúdo**:
   - Atualizar estatísticas do projeto
   - Modificar status das fases
   - Adicionar novos marcos

2. **Dependências**:
   - Verificar atualizações do Mermaid.js
   - Testar compatibilidade com novos navegadores

3. **Performance**:
   - Otimizar imagens
   - Minificar CSS/JS se necessário
   - Verificar tempo de carregamento

### Backup e Versionamento
```bash
# Backup regular
git add .
git commit -m "Update: [descrição da mudança]"
git push origin main

# Tags para versões importantes
git tag -a v1.1.0 -m "Versão 1.1.0 - Adição de novos gráficos"
git push origin v1.1.0
```

### Monitoramento
- **Analytics**: Implementar Google Analytics se necessário
- **Logs**: Monitorar console do navegador para erros
- **Performance**: Usar DevTools para análise

## 🐛 Solução de Problemas

### Problemas Comuns

#### 1. Gráficos Mermaid não carregam
**Sintomas**: Área em branco onde deveria aparecer o gráfico
**Soluções**:
```javascript
// Verificar se Mermaid carregou
if (typeof mermaid !== 'undefined') {
    mermaid.init();
} else {
    console.error('Mermaid não carregou');
}
```

#### 2. Estilos CSS não aplicados
**Sintomas**: Layout quebrado ou sem estilo
**Soluções**:
- Verificar caminho do arquivo CSS
- Verificar sintaxe CSS
- Limpar cache do navegador (Ctrl+F5)

#### 3. Servidor local não inicia
**Sintomas**: Erro ao executar `python3 -m http.server`
**Soluções**:
```bash
# Verificar se Python está instalado
python3 --version

# Tentar porta diferente
python3 -m http.server 3000

# Verificar se porta está em uso
netstat -an | grep :8080
```

#### 4. Site não carrega no GitHub Pages
**Sintomas**: 404 ou página em branco
**Soluções**:
- Verificar se `index.html` está na raiz
- Aguardar propagação (até 10 minutos)
- Verificar configurações do repositório

### Logs e Debug

#### Console do Navegador
```javascript
// Habilitar debug
localStorage.setItem('debug', 'true');

// Verificar erros
console.log('Site carregado com sucesso');
```

#### Validação HTML/CSS
- **HTML**: [W3C Markup Validator](https://validator.w3.org/)
- **CSS**: [W3C CSS Validator](https://jigsaw.w3.org/css-validator/)

### Performance

#### Otimização de Carregamento
```html
<!-- Preload de recursos críticos -->
<link rel="preload" href="css/dynamic-styles.css" as="style">
<link rel="preload" href="js/project-graphs.js" as="script">
```

#### Compressão
```bash
# Minificar CSS (opcional)
npm install -g clean-css-cli
cleancss -o style.min.css dynamic-styles.css

# Minificar JavaScript (opcional)
npm install -g uglify-js
uglifyjs project-graphs.js -o project-graphs.min.js
```

## 📞 Suporte

### Contatos Técnicos
- **Desenvolvimento**: MEX Energia - Equipe de Tecnologia
- **Conteúdo**: Equipe de Projeto Transformacional
- **Infraestrutura**: Administrador de Sistemas

### Recursos Adicionais
- **Documentação Mermaid**: [mermaid-js.github.io](https://mermaid-js.github.io/)
- **MDN Web Docs**: [developer.mozilla.org](https://developer.mozilla.org/)
- **GitHub Pages**: [pages.github.com](https://pages.github.com/)

---

**Última atualização**: Junho 2025  
**Versão da documentação**: 1.0.0  
**Compatibilidade**: Navegadores modernos (Chrome 80+, Firefox 75+, Safari 13+, Edge 80+)

