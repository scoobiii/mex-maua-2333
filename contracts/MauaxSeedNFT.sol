// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MAUAX Seed Round NFT
 * @author GOS3 Team
 * @notice Contrato para o NFT único (Token ID 1) que representa o direito sobre
 * a rodada de investimento de R$ 15 Milhões da Fase 0.
 * @dev Este contrato emite um único NFT e transfere sua propriedade para o contrato
 * de venda (MauaxSeedSale.sol), que atuará como custodiante durante a captação.
 */
contract MauaxSeedNFT is ERC721, Ownable {
    
    uint256 public constant TOKEN_ID = 1;

    constructor() ERC721("MAUAX Seed Round Investment", "MAUAX-SEED") Ownable(msg.sender) {
        // Construtor vazio. A emissão é feita em uma função separada.
    }

    /**
     * @notice Emite o NFT SEED e o envia para o contrato de venda.
     * @dev Deve ser chamado apenas uma vez pelo deployer inicial.
     * @param saleContractAddress O endereço do contrato MauaxSeedSale.sol.
     */
    function mintToSaleContract(address saleContractAddress) external onlyOwner {
        require(totalSupply() == 0, "SEED NFT can only be minted once");
        require(saleContractAddress != address(0), "Invalid sale contract address");
        
        _safeMint(saleContractAddress, TOKEN_ID);
    }
    
    // A função `transferOwnership` é herdada do Ownable.sol e será usada para
    // transferir o controle administrativo do contrato para a Gnosis Safe da MEXX.
}
