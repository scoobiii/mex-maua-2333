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
    
    uint256 public immutable maturityDate;
    uint256 public immutable couponRateBPS;
    IERC20 public immutable paymentToken;
    
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

    function distributeInterest(uint256 totalInterestAmount) external onlyOwner {
        require(block.timestamp >= nextPaymentTimestamp, "Coupon not due yet");
        require(totalInterestAmount > 0, "Amount must be positive");
        
        currentPeriodId++;
        couponPeriods[currentPeriodId] = CouponPeriod({
            totalInterestDistributed: totalInterestAmount,
            tokenTotalSupplyAtPayment: totalSupply()
        });
        
        nextPaymentTimestamp = block.timestamp + PAYMENT_INTERVAL;
        
        uint256 initialBalance = paymentToken.balanceOf(address(this));
        paymentToken.transferFrom(msg.sender, address(this), totalInterestAmount);
        require(paymentToken.balanceOf(address(this)) >= initialBalance + totalInterestAmount, "Deposit failed");
        
        emit InterestDistributed(currentPeriodId, totalInterestAmount);
    }
    
    function claimInterest(uint256 periodId) external {
        require(periodId > 0 && periodId <= currentPeriodId, "Invalid period");
        
        CouponPeriod storage period = couponPeriods[periodId];
        uint256 userBalance = balanceOf(msg.sender);
        
        uint256 totalOwed = (userBalance * period.totalInterestDistributed) / period.tokenTotalSupplyAtPayment;
        uint256 alreadyWithdrawn = withdrawnInterest[periodId][msg.sender];
        
        uint256 amountToWithdraw = totalOwed - alreadyWithdrawn;
        require(amountToWithdraw > 0, "No interest to claim");
        
        withdrawnInterest[periodId][msg.sender] = totalOwed;
        
        paymentToken.transfer(msg.sender, amountToWithdraw);
        emit InterestClaimed(periodId, msg.sender, amountToWithdraw);
    }
}
