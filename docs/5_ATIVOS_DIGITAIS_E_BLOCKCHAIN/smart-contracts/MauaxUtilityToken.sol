// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MAUAX Utility Token
 * @author GOS3 Team
 * @notice Este contrato gerencia o MAUAX-C, a criptomoeda de utilidade fungível (ERC-20)
 * do ecossistema MAUAX.
 * @dev A propriedade do contrato (ownership) será detida pela Gnosis Safe Multisig do Consórcio
 * e, futuramente, transferida para a MAUAX DAO. Apenas o "dono" pode mintar novos tokens,
 * seguindo o cronograma de emissão (vesting) definido no tokenomics do projeto.
 */
contract MauaxUtilityToken is ERC20, ERC20Burnable, Ownable {

    /**
     * @dev O construtor define o nome e o símbolo do token.
     * NENHUM token é criado na implantação; eles serão mintados conforme o cronograma.
     */
    constructor() ERC20("MAUAX Utility Token", "MAUAX-C") Ownable(msg.sender) {
        // O msg.sender (deployer) se torna o dono inicial.
        // A propriedade deve ser transferida para a Gnosis Safe imediatamente.
    }

    /**
     * @notice Cria (minta) uma nova quantidade de tokens e os atribui a um endereço.
     * @dev Apenas o dono do contrato (a Gnosis Safe / DAO) pode chamar esta função.
     * Esta função será usada para executar o cronograma de emissão (vesting) das Fases I e II.
     * @param to O endereço que receberá os novos tokens.
     * @param amount A quantidade de tokens a ser criada (em sua menor unidade, ex: com 18 decimais).
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice Transfere a propriedade do contrato para um novo endereço.
     * @dev Função CRÍTICA para transferir o controle administrativo para a Gnosis Safe Multisig
     * e, eventualmente, para o contrato de governança da MAUAX DAO.
     */
    function transferContractOwnership(address newOwner) external onlyOwner {
        transferOwnership(newOwner);
    }
}
