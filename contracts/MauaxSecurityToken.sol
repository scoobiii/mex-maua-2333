// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MAUAX Security Token (Template)
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX - Estrutura Jurídica e de Compliance.
 * @notice Template base para Security Tokens (MAUAX-S, B, D, T) com whitelist de investidores.
 * @dev Combina ERC20 com um sistema de whitelist baseado em Ownable para conformidade CVM.
 * Apenas endereços na whitelist podem transacionar os tokens, exceto para emissão e queima.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract MauaxSecurityToken is ERC20, Ownable {
    
    mapping(address => bool) public isWhitelisted;
    
    event InvestorWhitelisted(address indexed investor);
    event InvestorRemoved(address indexed investor);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {}

    function addToWhitelist(address investor) external onlyOwner {
        require(investor != address(0), "Cannot whitelist the zero address");
        isWhitelisted[investor] = true;
        emit InvestorWhitelisted(investor);
    }
    
    function removeFromWhitelist(address investor) external onlyOwner {
        isWhitelisted[investor] = false;
        emit InvestorRemoved(investor);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(isWhitelisted[to], "Recipient not whitelisted");
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal view virtual override {
        super._beforeTokenTransfer(from, to, amount);
        
        if (from == address(0) || to == address(0)) {
            return;
        }
        
        require(isWhitelisted[from], "Sender not whitelisted");
        require(isWhitelisted[to], "Recipient not whitelisted");
    }
}
