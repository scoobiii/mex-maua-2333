// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MAUAX Utility Token (MAUAX-C)
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX.
 * @notice Contrato para o MAUAX-C, a criptomoeda de utilidade (ERC-20) do ecossistema.
 * @dev A propriedade deve ser transferida para a Gnosis Safe da DAO para controlar a emissão.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MauaxUtilityToken is ERC20, ERC20Burnable, Ownable {

    constructor() ERC20("MAUAX Utility Token", "MAUAX-C") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
