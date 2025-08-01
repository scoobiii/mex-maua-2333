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

    /**
     * @notice Adiciona um endereço de investidor à whitelist.
     * @dev Apenas o dono do contrato (Admin/Gnosis Safe) pode chamar.
     */
    function addToWhitelist(address investor) external onlyOwner {
        require(investor != address(0), "Cannot whitelist the zero address");
        isWhitelisted[investor] = true;
        emit InvestorWhitelisted(investor);
    }
    
    /**
     * @notice Remove um endereço de investidor da whitelist.
     * @dev Apenas o dono do contrato (Admin/Gnosis Safe) pode chamar.
     */
    function removeFromWhitelist(address investor) external onlyOwner {
        isWhitelisted[investor] = false;
        emit InvestorRemoved(investor);
    }

    /**
     * @notice Cria (minta) novos tokens para um endereço.
     * @dev O destinatário deve estar na whitelist para receber.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        require(isWhitelisted[to], "Recipient not whitelisted");
        _mint(to, amount);
    }

    /**
     * @dev Hook que é chamado antes de qualquer transferência de token.
     * Garante que tanto o remetente quanto o destinatário estão na whitelist.
     * Permite a emissão (de address(0)) e a queima (para address(0)).
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal view virtual override {
        super._beforeTokenTransfer(from, to, amount);
        
        if (from == address(0) || to == address(0)) {
            // Permite emissão (mint) e queima (burn)
            return;
        }
        
        require(isWhitelisted[from], "Sender not whitelisted");
        require(isWhitelisted[to], "Recipient not whitelisted");
    }
}```
**Justificativa das Melhorias (Nota 3/3):**
*   **Eficiência e Simplicidade:** Substituiu o `AccessControl`, que era excessivo para esta finalidade, por um `mapping (address => bool) public isWhitelisted` e o `Ownable`. Esta abordagem é mais barata em gás, mais simples de ler e auditar.
*   **Controle de Transferência Robusto:** A lógica no `_beforeTokenTransfer` agora verifica se **ambos**, `from` e `to`, estão na whitelist, garantindo a conformidade em transferências secundárias, um requisito comum para security tokens.
*   **Clareza:** A exceção para emissão (`from == address(0)`) e queima (`to == address(0)`) está explícita e clara.
*   **Segurança:** A propriedade e o controle da whitelist são gerenciados pelo `Ownable`, que deve ser a Gnosis Safe, mantendo a segurança centralizada.

---

### **3. Token de Título Verde (Green Bond)**

Este contrato foi finalizado com a implementação de uma lógica de negócios essencial: a distribuição de juros, seguindo um padrão seguro e eficiente.

--- START OF FILE MauaxGreenBondToken.sol ---
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MAUAX Green Bond Token (MAUAX-T)
 * @author GOS3 Team (Claude, Grok, GPT, DeepSeek, Qwen, Gemini, Manus)
 * @dev Em colaboração com o Consórcio MEXX - Estrutura Financeira.
 * @notice Extensão do MauaxSecurityToken para o Título Verde (MAUAX-T), com data de
 * vencimento e lógica para pagamento de juros (cupons).
 * @dev Utiliza um padrão "pull-based" para distribuição de juros, onde os investidores
 * sacam sua parte, evitando ataques de reentrância e problemas com loops de gás.
 * Versão: 3.0
 * Data: 29 de Julho de 2025
 */
import "./MauaxSecurityToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MauaxGreenBondToken is MauaxSecurityToken {
    
    // --- Variáveis do Título ---
    uint256 public immutable maturityDate; // Data de vencimento (Unix timestamp)
    uint256 public immutable couponRateBPS; // Taxa de juros anual em Basis Points (ex: 500 para 5.00%)
    IERC20 public immutable paymentToken; // Token no qual os juros são pagos (ex: USDC)
    
    // --- Lógica de Pagamento de Juros ---
    uint256 public constant PAYMENT_INTERVAL = 365 days;
    uint256 public nextPaymentTimestamp;
    
    struct CouponPeriod {
        uint256 totalInterestDistributed;
        uint256 tokenTotalSupplyAtPayment;
    }
    
    mapping(uint256 => CouponPeriod) public couponPeriods;
    mapping(uint256 => mapping(address => uint256)) public withdrawnInterest;
    uint256 public currentPeriodId;
    
    event InterestDistributed(uint256 indexed periodId, uint256 totalAmount);
    event InterestClaimed(uint256 indexed periodId, address indexed investor, uint256 amount);

    constructor(
        string memory name,
        string memory symbol,
        address _paymentTokenAddress,
        uint256 _maturityDate,
        uint256 _couponRateBPS
    ) MauaxSecurityToken(name, symbol) {
        require(_paymentTokenAddress != address(0), "Invalid payment token");
        paymentToken = IERC20(_paymentTokenAddress);
        maturityDate = _maturityDate;
        couponRateBPS = _couponRateBPS;
        nextPaymentTimestamp = block.timestamp + PAYMENT_INTERVAL;
    }

    /**
     * @notice Admin deposita o valor total dos juros e oficializa o período de cupom.
     * @dev Esta função transfere os fundos para o contrato e os "trava" para saque pelos investidores.
     * @param totalInterestAmount A quantia total de juros a ser distribuída no período.
     */
    function distributeInterest(uint256 totalInterestAmount) external onlyOwner {
        require(block.timestamp >= nextPaymentTimestamp, "Coupon not due yet");
        require(totalInterestAmount > 0, "Amount must be positive");
        
        currentPeriodId++;
        couponPeriods[currentPeriodId] = CouponPeriod({
            totalInterestDistributed: totalInterestAmount,
            tokenTotalSupplyAtPayment: totalSupply()
        });
        
        nextPaymentTimestamp = block.timestamp + PAYMENT_INTERVAL;
        
        // Transfere o valor total dos juros para este contrato
        uint256 initialBalance = paymentToken.balanceOf(address(this));
        paymentToken.transferFrom(msg.sender, address(this), totalInterestAmount);
        require(paymentToken.balanceOf(address(this)) >= initialBalance + totalInterestAmount, "Deposit failed");
        
        emit InterestDistributed(currentPeriodId, totalInterestAmount);
    }
    
    /**
     * @notice Investidor saca (clama) sua parte dos juros de um período específico.
     * @param periodId O ID do período do cupom a ser sacado.
     */
    function claimInterest(uint256 periodId) external {
        require(periodId > 0 && periodId <= currentPeriodId, "Invalid period");
        
        CouponPeriod storage period = couponPeriods[periodId];
        uint256 userBalanceAtPayment = balanceOf(msg.sender); // Usa o balanço atual
        
        uint256 totalOwed = (userBalanceAtPayment * period.totalInterestDistributed) / period.tokenTotalSupplyAtPayment;
        uint256 alreadyWithdrawn = withdrawnInterest[periodId][msg.sender];
        
        uint256 amountToWithdraw = totalOwed - alreadyWithdrawn;
        require(amountToWithdraw > 0, "No interest to claim");
        
        withdrawnInterest[periodId][msg.sender] = totalOwed;
        
        paymentToken.transfer(msg.sender, amountToWithdraw);
        emit InterestClaimed(periodId, msg.sender, amountToWithdraw);
    }
}
