// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MAUAX Governance Token (MAUAX-G)
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX.
 * @notice Contrato para os NFTs de governança (MAUAX-G) da MAUAX DAO.
 * @dev Implementa o padrão ERC-721. Apenas 100 NFTs ("Founder's Edition") podem ser criados.
 * A propriedade do contrato deve ser transferida para a Gnosis Safe da DAO.
 * Utiliza ERC721Enumerable para permitir a contagem de tokens de governança on-chain.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MauaxFoundersNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 public constant MAX_SUPPLY = 100;

    constructor() ERC721("MAUAX Governance Token", "MAUAX-G") Ownable(msg.sender) {}

    /**
     * @notice Cria (minta) um novo NFT de governança e o atribui a um endereço.
     * @dev Apenas o dono do contrato (Gnosis Safe / DAO) pode chamar esta função.
     * A emissão é limitada pela constante MAX_SUPPLY.
     * @param to O endereço que receberá o novo NFT.
     */
    function safeMint(address to) external onlyOwner {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "MAUAX-G: Max supply reached");
        
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
    }

    // As funções a seguir são overrides necessários devido à herança de ERC721 e ERC721Enumerable.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
