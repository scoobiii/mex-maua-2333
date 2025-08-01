// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MAUAX Seed Round NFT
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX.
 * @notice Contrato para o NFT único (Token ID 1) que representa o direito sobre
 * a rodada de investimento de R$ 15 Milhões da Fase 0.
 * @dev Garante que apenas um único NFT pode ser emitido em toda a vida do contrato.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MauaxSeedNFT is ERC721, Ownable {
    
    uint256 public constant TOKEN_ID = 1;

    constructor() ERC721("MAUAX Seed Round Investment", "MAUAX-SEED") Ownable(msg.sender) {}

    function mintToSaleContract(address saleContractAddress) external onlyOwner {
        require(totalSupply() == 0, "SEED NFT can only be minted once");
        require(saleContractAddress != address(0), "Invalid sale contract address");
        
        _safeMint(saleContractAddress, TOKEN_ID);
    }
}
