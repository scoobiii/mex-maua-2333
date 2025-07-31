// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title MAUAX Security Token
 * @dev Template base para os Security Tokens (MAUAX-S, B, D, T).
 * Combina ERC20 com AccessControl para gerenciar uma whitelist de investidores,
 * essencial para a conformidade com a CVM.
 */
contract MauaxSecurityToken is ERC20, AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function addToWhitelist(address investor) external onlyRole(ADMIN_ROLE) {
        _setRoleAdmin(keccak256(abi.encodePacked("WHITELISTED_INVESTOR")), ADMIN_ROLE);
        grantRole(keccak256(abi.encodePacked("WHITELISTED_INVESTOR")), investor);
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal view override {
        super._beforeTokenTransfer(from, to, amount);
        // Permite a emissão (de 'address(0)') e transferências para investidores na whitelist.
        require(from == address(0) || hasRole(keccak256(abi.encodePacked("WHITELISTED_INVESTOR")), to), "Recipient not whitelisted");
    }
}
