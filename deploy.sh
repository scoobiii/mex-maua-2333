#!/bin/bash

# Script de Deploy Automatizado - Projeto Transformacional Mauá
# Versão: 1.0.0
# Autor: MEX Energia - Equipe de Tecnologia

set -e  # Parar execução em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
PROJECT_NAME="mex-project-site"
GITHUB_REPO="https://github.com/scoobiii/mex-project-site.git"
LOCAL_PORT=8080
DEPLOY_BRANCH="main"

# Função para logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Verificar dependências
check_dependencies() {
    log "Verificando dependências..."
    
    # Verificar Python
    if command -v python3 &> /dev/null; then
        success "Python3 encontrado: $(python3 --version)"
    else
        error "Python3 não encontrado. Instale Python 3.6+"
        exit 1
    fi
    
    # Verificar Git
    if command -v git &> /dev/null; then
        success "Git encontrado: $(git --version)"
    else
        error "Git não encontrado. Instale Git 2.20+"
        exit 1
    fi
    
    # Verificar Node.js (opcional)
    if command -v node &> /dev/null; then
        success "Node.js encontrado: $(node --version)"
    else
        warning "Node.js não encontrado (opcional para desenvolvimento)"
    fi
}

# Configurar ambiente local
setup_local() {
    log "Configurando ambiente local..."
    
    # Criar diretórios necessários
    mkdir -p docs assets/images assets/icons
    
    # Criar .gitignore se não existir
    if [ ! -f .gitignore ]; then
        cat > .gitignore << EOF
# Logs
*.log
npm-debug.log*

# Runtime data
pids
*.pid
*.seed

# Coverage directory used by tools like istanbul
coverage

# Dependency directories
node_modules/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo

# Temporary files
*.tmp
*.temp

# Local server files
*.pid
EOF
        success "Arquivo .gitignore criado"
    fi
    
    # Verificar estrutura de arquivos
    if [ -f "index.html" ]; then
        success "index.html encontrado"
    else
        error "index.html não encontrado!"
        exit 1
    fi
    
    if [ -f "css/dynamic-styles.css" ]; then
        success "CSS encontrado"
    else
        warning "CSS adicional não encontrado"
    fi
    
    if [ -f "js/project-graphs.js" ]; then
        success "JavaScript encontrado"
    else
        warning "JavaScript adicional não encontrado"
    fi
}

# Iniciar servidor local
start_local_server() {
    log "Iniciando servidor local na porta $LOCAL_PORT..."
    
    # Verificar se porta está em uso
    if lsof -Pi :$LOCAL_PORT -sTCP:LISTEN -t >/dev/null ; then
        warning "Porta $LOCAL_PORT já está em uso"
        read -p "Deseja parar o processo existente? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill $(lsof -t -i:$LOCAL_PORT) 2>/dev/null || true
            success "Processo anterior finalizado"
        else
            LOCAL_PORT=$((LOCAL_PORT + 1))
            warning "Usando porta alternativa: $LOCAL_PORT"
        fi
    fi
    
    # Iniciar servidor
    python3 -m http.server $LOCAL_PORT &
    SERVER_PID=$!
    
    # Aguardar servidor iniciar
    sleep 2
    
    if kill -0 $SERVER_PID 2>/dev/null; then
        success "Servidor iniciado com sucesso!"
        success "Acesse: http://localhost:$LOCAL_PORT"
        echo $SERVER_PID > .server.pid
    else
        error "Falha ao iniciar servidor"
        exit 1
    fi
}

# Parar servidor local
stop_local_server() {
    log "Parando servidor local..."
    
    if [ -f .server.pid ]; then
        PID=$(cat .server.pid)
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            rm .server.pid
            success "Servidor parado"
        else
            warning "Servidor já estava parado"
            rm .server.pid
        fi
    else
        warning "Arquivo PID não encontrado"
    fi
}

# Validar arquivos
validate_files() {
    log "Validando arquivos..."
    
    # Verificar HTML básico
    if grep -q "<!DOCTYPE html>" index.html; then
        success "HTML válido (DOCTYPE encontrado)"
    else
        warning "DOCTYPE HTML não encontrado"
    fi
    
    # Verificar Mermaid
    if grep -q "mermaid" index.html; then
        success "Mermaid.js encontrado"
    else
        warning "Mermaid.js não encontrado"
    fi
    
    # Verificar responsividade
    if grep -q "viewport" index.html; then
        success "Meta viewport encontrado (responsivo)"
    else
        warning "Meta viewport não encontrado"
    fi
}

# Deploy para GitHub Pages
deploy_github() {
    log "Iniciando deploy para GitHub Pages..."
    
    # Verificar se é um repositório Git
    if [ ! -d .git ]; then
        log "Inicializando repositório Git..."
        git init
        git branch -M $DEPLOY_BRANCH
    fi
    
    # Adicionar arquivos
    git add .
    
    # Commit
    COMMIT_MSG="Deploy: $(date +'%Y-%m-%d %H:%M:%S') - Projeto Transformacional Mauá"
    git commit -m "$COMMIT_MSG" || warning "Nenhuma mudança para commit"
    
    # Push
    if git remote get-url origin &>/dev/null; then
        git push origin $DEPLOY_BRANCH
        success "Deploy realizado com sucesso!"
        success "Site disponível em: https://scoobiii.github.io/mex-dashboard/"
    else
        warning "Remote origin não configurado"
        log "Configure com: git remote add origin $GITHUB_REPO"
    fi
}

# Gerar relatório do site
generate_report() {
    log "Gerando relatório do site..."
    
    REPORT_FILE="site-report-$(date +'%Y%m%d-%H%M%S').txt"
    
    cat > $REPORT_FILE << EOF
# Relatório do Site - Projeto Transformacional Mauá
Gerado em: $(date)

## Estrutura de Arquivos
$(find . -type f -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.md" | sort)

## Tamanho dos Arquivos
$(du -h *.html css/*.css js/*.js 2>/dev/null | sort -hr)

## Estatísticas
- Total de arquivos HTML: $(find . -name "*.html" | wc -l)
- Total de arquivos CSS: $(find . -name "*.css" | wc -l)
- Total de arquivos JS: $(find . -name "*.js" | wc -l)
- Tamanho total: $(du -sh . | cut -f1)

## Dependências Externas
$(grep -h "https://" *.html | grep -E "(cdn|googleapis|unpkg)" | sort -u)

## Gráficos Mermaid Detectados
$(grep -n "mermaid" *.html js/*.js 2>/dev/null | wc -l) referências encontradas

## Status do Git
$(git status --porcelain 2>/dev/null || echo "Não é um repositório Git")

## Último Commit
$(git log -1 --oneline 2>/dev/null || echo "Nenhum commit encontrado")
EOF
    
    success "Relatório gerado: $REPORT_FILE"
}

# Função de ajuda
show_help() {
    echo "Script de Deploy - Projeto Transformacional Mauá"
    echo ""
    echo "Uso: $0 [COMANDO]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  setup     - Configurar ambiente local"
    echo "  start     - Iniciar servidor local"
    echo "  stop      - Parar servidor local"
    echo "  validate  - Validar arquivos do site"
    echo "  deploy    - Deploy para GitHub Pages"
    echo "  report    - Gerar relatório do site"
    echo "  all       - Executar setup + start + validate"
    echo "  help      - Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 setup"
    echo "  $0 start"
    echo "  $0 deploy"
}

# Menu principal
main() {
    case "${1:-help}" in
        "setup")
            check_dependencies
            setup_local
            ;;
        "start")
            start_local_server
            ;;
        "stop")
            stop_local_server
            ;;
        "validate")
            validate_files
            ;;
        "deploy")
            validate_files
            deploy_github
            ;;
        "report")
            generate_report
            ;;
        "all")
            check_dependencies
            setup_local
            start_local_server
            validate_files
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Executar função principal
main "$@"

