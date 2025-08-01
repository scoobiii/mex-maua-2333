// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol";
import "@manifoldxyz/creator-core-solidity/contracts/core/IERC721CreatorCore.sol";
import "@manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";

/**
 * @title MAUAX Pedra Fundamental Extension
 * @notice Smart Contract para o NFT "A Pedra que Abre Caminhos" #0008
 * @dev Extensão para Manifold Creator Core - Marco Inaugural do Ecossistema MAUAX
 * @author Consórcio MAUAX
 */
contract MAUAXPedraFundamental is AdminControl, ICreatorExtensionTokenURI {
    
    // ====== EVENTOS ======
    event PedraFundamentalMinted(address indexed to, uint256 indexed tokenId);
    event MetadataUpdated(uint256 indexed tokenId, string newMetadata);
    event EcosystemMilestone(string milestone, uint256 timestamp);
    event RevenueDistributed(uint256 amount, uint256 timestamp);
    event RevenueShareUpdated(uint256 index, address newWallet, string entity);
    
    // ====== ESTRUTURAS ======
    struct PedraMetadata {
        string title;
        string description;
        string imageURI;
        string animationURI;
        uint256 mintTimestamp;
        address originalOwner;
        bool isFoundational;
        string[] attributes;
    }
    
    struct RevenueShare {
        address wallet;
        uint256 percentage;
        string entity;
    }
    
    // ====== VARIÁVEIS DE ESTADO ======
    address public immutable creator;
    bool public isPedraFundamentalMinted;
    uint256 public constant PEDRA_FUNDAMENTAL_ID = 8; // Token #0008
    
    // Configuração de Revenue Share
    RevenueShare[3] public revenueShares;
    uint256 public totalSales;
    uint256 public constant ROYALTY_PERCENTAGE = 750; // 7.5% em basis points
    
    mapping(uint256 => PedraMetadata) private _tokenMetadata;
    
    // URLs base para metadados
    string private _baseURI = "https://metadata.mauax.city/nft/";
    string private _contractURI = "https://metadata.mauax.city/contract.json";
    
    // ====== MODIFICADORES ======
    modifier onlyValidToken(uint256 tokenId) {
        require(tokenId == PEDRA_FUNDAMENTAL_ID, "Token nao existe");
        _;
    }
    
    // ====== CONSTRUTOR ======
    constructor(address _creator) {
        creator = _creator;
        _initializePedraFundamental();
        _initializeRevenueShares();
    }
    
    // ====== FUNÇÃO DE INICIALIZAÇÃO ======
    function _initializePedraFundamental() private {
        _tokenMetadata[PEDRA_FUNDAMENTAL_ID] = PedraMetadata({
            title: "A Pedra que Abre Caminhos",
            description: "Onde o Futuro de Maua e Forjado em Arte, Inovacao e Proposito. Marco inaugural do ecossistema MAUAX - Um manifesto visual que representa o primeiro passo da transformacao de Maua em uma cidade inteligente, sustentavel e conectada.",
            imageURI: "https://assets.mauax.city/nft/pedra-fundamental-0008.jpg",
            animationURI: "https://assets.mauax.city/nft/pedra-fundamental-0008.mp4",
            mintTimestamp: 0,
            originalOwner: address(0),
            isFoundational: true,
            attributes: [
                "Marco Inaugural",
                "Edicao Unica", 
                "Lazy Minting",
                "Polygon",
                "Manifesto Visual"
            ]
        });
    }
    
    /**
     * @notice Inicializa as contas de revenue share
     */
    function _initializeRevenueShares() private {
        // IMPORTANTE: Substitua pelos endereços reais antes do deploy
        revenueShares[0] = RevenueShare({
            wallet: 0x1234567890123456789012345678901234567890, // MEX energIA - Substituir
            percentage: 55,
            entity: "MEX energIA"
        });
        
        revenueShares[1] = RevenueShare({
            wallet: 0x2345678901234567890123456789012345678901, // Secretaria - Substituir
            percentage: 5,
            entity: "Secretaria Relacoes Institucionais"
        });
        
        revenueShares[2] = RevenueShare({
            wallet: 0x3456789012345678901234567890123456789012, // Oliveira & Oliveira - Substituir
            percentage: 40,
            entity: "Oliveira & Oliveira Assessoria"
        });
    }
    
    // ====== FUNÇÃO PRINCIPAL DE MINT ======
    /**
     * @notice Cunha a Pedra Fundamental #0008 - Única e Histórica
     * @param to Endereço do destinatário
     */
    function mintPedraFundamental(address to) external adminRequired {
        require(!isPedraFundamentalMinted, "Pedra Fundamental ja foi cunhada");
        require(to != address(0), "Endereco invalido");
        
        // Cunha o token através do Manifold Creator Core
        uint256 tokenId = IERC721CreatorCore(creator).mintExtension(to);
        require(tokenId == PEDRA_FUNDAMENTAL_ID, "Token ID incorreto");
        
        // Atualiza metadados
        _tokenMetadata[PEDRA_FUNDAMENTAL_ID].mintTimestamp = block.timestamp;
        _tokenMetadata[PEDRA_FUNDAMENTAL_ID].originalOwner = to;
        
        isPedraFundamentalMinted = true;
        
        emit PedraFundamentalMinted(to, tokenId);
        emit EcosystemMilestone("Pedra Fundamental Cunhada", block.timestamp);
    }
    
    // ====== IMPLEMENTAÇÃO ICreatorExtensionTokenURI ======
    function tokenURI(address creator_, uint256 tokenId) 
        external 
        view 
        override 
        onlyValidToken(tokenId) 
        returns (string memory) 
    {
        require(creator_ == creator, "Creator invalido");
        return string(abi.encodePacked(_baseURI, "0008.json"));
    }
    
    // ====== FUNÇÕES DE METADADOS ======
    /**
     * @notice Retorna metadados completos da Pedra Fundamental
     */
    function getPedraMetadata() external view returns (PedraMetadata memory) {
        return _tokenMetadata[PEDRA_FUNDAMENTAL_ID];
    }
    
    /**
     * @notice Atualiza URIs de metadados (apenas admin)
     */
    function updateMetadataURIs(
        string calldata newImageURI,
        string calldata newAnimationURI
    ) external adminRequired {
        _tokenMetadata[PEDRA_FUNDAMENTAL_ID].imageURI = newImageURI;
        _tokenMetadata[PEDRA_FUNDAMENTAL_ID].animationURI = newAnimationURI;
        
        emit MetadataUpdated(PEDRA_FUNDAMENTAL_ID, newImageURI);
    }
    
    // ====== FUNÇÕES DE MARCO HISTÓRICO ======
    /**
     * @notice Registra marcos do ecossistema MAUAX
     */
    function recordEcosystemMilestone(string calldata milestone) external adminRequired {
        emit EcosystemMilestone(milestone, block.timestamp);
    }
    
    // ====== FUNÇÕES DE INFORMAÇÃO ======
    function isTokenMinted() external view returns (bool) {
        return isPedraFundamentalMinted;
    }
    
    function getFoundationalInfo() external pure returns (string memory) {
        return "Projeto MAUAX: Transformando Maua em uma cidade inteligente, sustentavel e conectada. Ecossistema de US$ 20 bilhoes com 5 pilares integrados.";
    }
    
    // ====== INTERFACE SUPPORT ======
    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        virtual 
        override(AdminControl, IERC165) 
        returns (bool) 
    {
        return interfaceId == type(ICreatorExtensionTokenURI).interfaceId ||
               AdminControl.supportsInterface(interfaceId) ||
               super.supportsInterface(interfaceId);
    }
}
