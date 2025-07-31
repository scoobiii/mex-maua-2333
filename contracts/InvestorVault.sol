// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Investor Vault for MAUAX Seed Round
 * @author GOS3 Team
 * @notice Este contrato atua como um cofre (vault) para o NFT MAUAX-SEED,
 * governado pelos investidores da Fase 0.
 * @dev Utiliza AccessControl para gerenciar os papéis de membro e propostas.
 * As decisões são tomadas por votação ponderada com base na contribuição.
 */
contract InvestorVault is AccessControl, ReentrancyGuard {
    // --- Papéis ---
    bytes32 public constant MEMBER_ROLE = keccak256("MEMBER_ROLE");
    
    // --- Variáveis de Estado ---
    IERC721 public immutable mauaxSeedNFT;
    uint256 public totalInvestment;
    
    mapping(address => uint256) public memberContributions;
    
    struct Proposal {
        uint256 id;
        address target;
        bytes data;
        string description;
        uint256 executionTimestamp;
        bool executed;
        mapping(address => bool) hasVoted;
        uint256 votesFor;
    }
    
    Proposal[] public proposals;
    uint256 public proposalCount;
    uint256 public constant VOTING_PERIOD = 3 days; // Duração da votação
    uint256 public constant QUORUM_PERCENT = 51; // 51% de quórum para aprovar

    // --- Eventos ---
    event MemberAdded(address indexed member, uint256 contribution);
    event ProposalCreated(uint256 id, address indexed proposer, string description);
    event Voted(uint256 id, address indexed voter, uint256 weight);
    event ProposalExecuted(uint256 id);

    // --- Construtor ---
    constructor(address _nftAddress) {
        mauaxSeedNFT = IERC721(_nftAddress);
        // O deployer (o contrato MauaxSeedSale) se torna o admin inicial
        // para poder adicionar os membros.
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Adiciona um investidor como membro do cofre.
     * @dev Apenas o admin (o contrato de venda) pode chamar esta função.
     * @param member O endereço do investidor.
     * @param contribution A quantia que o investidor aportou.
     */
    function addMember(address member, uint256 contribution) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(MEMBER_ROLE, member);
        memberContributions[member] += contribution;
        totalInvestment += contribution;
        emit MemberAdded(member, contribution);
    }

    /**
     * @notice Cria uma nova proposta para ser votada pelos membros.
     * @param target O endereço do contrato a ser chamado (ex: o próprio NFT SEED).
     * @param data Os dados da chamada da função (ex: para transferir o NFT).
     * @param description Uma descrição legível da proposta.
     */
    function createProposal(address target, bytes memory data, string memory description) external onlyRole(MEMBER_ROLE) {
        proposalCount++;
        proposals.push(Proposal({
            id: proposalCount,
            target: target,
            data: data,
            description: description,
            executionTimestamp: block.timestamp + VOTING_PERIOD,
            executed: false,
            votesFor: 0
        }));
        emit ProposalCreated(proposalCount, msg.sender, description);
    }

    /**
     * @notice Permite que um membro vote em uma proposta.
     * @param proposalId O ID da proposta.
     */
    function vote(uint256 proposalId) external onlyRole(MEMBER_ROLE) {
        Proposal storage p = proposals[proposalId - 1];
        require(block.timestamp < p.executionTimestamp, "Voting period has ended");
        require(!p.hasVoted[msg.sender], "Already voted");

        p.hasVoted[msg.sender] = true;
        uint256 voteWeight = memberContributions[msg.sender];
        p.votesFor += voteWeight;
        
        emit Voted(proposalId, msg.sender, voteWeight);
    }

    /**
     * @notice Executa uma proposta que atingiu o quórum.
     * @param proposalId O ID da proposta.
     */
    function executeProposal(uint256 proposalId) external nonReentrant {
        Proposal storage p = proposals[proposalId - 1];
        require(block.timestamp >= p.executionTimestamp, "Voting period not yet ended");
        require(!p.executed, "Proposal already executed");
        
        uint256 quorum = (totalInvestment * QUORUM_PERCENT) / 100;
        require(p.votesFor >= quorum, "Quorum not reached");

        p.executed = true;
        (bool success, ) = p.target.call(p.data);
        require(success, "Execution failed");

        emit ProposalExecuted(proposalId);
    }
    
    // Função para receber o NFT SEED do contrato de venda
    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
