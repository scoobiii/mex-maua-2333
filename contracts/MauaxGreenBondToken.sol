// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MauaxSecurityToken.sol";

/**
 * @title MAUAX Green Bond Token
 * @dev Extensão do MauaxSecurityToken para representar um Título Verde (MAUAX-T),
 * com data de vencimento e lógica para pagamento de juros.
 */
contract MauaxGreenBondToken is MauaxSecurityToken {
    uint256 public immutable maturityDate; // Data de vencimento do título (em timestamp Unix)
    uint256 public immutable couponRate; // Taxa de juros anual (ex: 500 para 5.00%)

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maturityDate,
        uint256 _couponRate
    ) MauaxSecurityToken(name, symbol) {
        maturityDate = _maturityDate;
        couponRate = _couponRate;
    }

    // Lógica para distribuição de juros (coupon payments) seria adicionada aqui.
    // Ex: uma função `distributeInterest()` que o admin chama periodicamente.
}
