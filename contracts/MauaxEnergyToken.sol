// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MAUAX Energy Token (MAUAX-E)
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX.
 * @notice Token de utilidade (MAUAX-E) lastreado em energia real (RWA).
 * @dev Utiliza AccessControl para permitir que oráculos ou sistemas autorizados emitam tokens.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MauaxEnergyToken is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("MAUAX Energy Token", "MAUAX-E") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}
