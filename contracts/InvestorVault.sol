// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Investor Vault for MAUAX Seed Round
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX.
 * @notice Contrato que atua como cofre para o MAUAX-SEED NFT, governado pelos
 * investidores da Fase 0 através de votação ponderada.
 * @dev Utiliza AccessControl, ReentrancyGuard e lida com o recebimento de ERC721.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract InvestorVault is AccessControl, ReentrancyGuard {
    bytes32 public constant MEMBER_ROLE = keccak256("MEMBER_ROLE");
    
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
    uint256 public constant VOTING_PERIOD = 3 days;
    uint256 public constant QUORUM_PERCENT = 51;

    event MemberAdded(address indexed member, uint256 contribution);
    event ProposalCreated(uint256 id, address indexed proposer, string description);
    event Voted(uint256 id, address indexed voter, uint256 weight);
    event ProposalExecuted(uint256 id);

    constructor(address _nftAddress) {
        mauaxSeedNFT = IERC20(_nftAddress);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function addMember(address member, uint256 contribution) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(MEMBER_ROLE, member);
        memberContributions[member] += contribution;
        totalInvestment += contribution;
        emit MemberAdded(member, contribution);
    }

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

    function vote(uint256 proposalId) external onlyRole(MEMBER_ROLE) {
        Proposal storage p = proposals[proposalId - 1];
        require(block.timestamp < p.executionTimestamp, "Voting period has ended");
        require(!p.hasVoted[msg.sender], "Already voted");

        p.hasVoted[msg.sender] = true;
        uint256 voteWeight = memberContributions[msg.sender];
        p.votesFor += voteWeight;
        
        emit Voted(proposalId, msg.sender, voteWeight);
    }

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
    
    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
