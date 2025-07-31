/*
 * SCRIPT DE IMPLANTAÇÃO (DEPLOY) COMPLETO
 * Versão: 2.0
 * Data: 22 de Julho de 2025
 * Autor: GOS3 Team
 * Descrição: Implanta TODOS os smart contracts do ecossistema MAUAX,
 * incluindo as instâncias especializadas dos Security Tokens.
 */

const hre = require("hardhat");

async function main() {
    console.log("🚀 Iniciando implantação completa dos contratos MAUAX na rede:", hre.network.name);
    const [deployer] = await hre.ethers.getSigners();
    console.log("Usando a conta do deployer:", deployer.address);
    console.log("Saldo da conta:", (await deployer.getBalance()).toString());

    // --- PARÂMETROS GLOBAIS (❗ SUBSTITUIR) ---
    const IPFS_BASE_URI_FOUNDERS = "ipfs://YOUR_FOUNDERS_METADATA_CID_HERE/";
    
    console.log("\n--- [FASE 1/3] Implantando Contratos de Utilidade e Governança ---");

    // 1. MauaxFoundersNFT (MAUAX-G)
    const MauaxFoundersNFT = await hre.ethers.getContractFactory("MauaxFoundersNFT");
    const mauaxFoundersNFT = await MauaxFoundersNFT.deploy(IPFS_BASE_URI_FOUNDERS);
    await mauaxFoundersNFT.deployed();
    console.log("✅ Contrato MAUAX-G (NFT) implantado em:", mauaxFoundersNFT.address);

    // 2. MauaxUtilityToken (MAUAX-C)
    const MauaxUtilityToken = await hre.ethers.getContractFactory("MauaxUtilityToken");
    const mauaxUtilityToken = await MauaxUtilityToken.deploy();
    await mauaxUtilityToken.deployed();
    console.log("✅ Contrato MAUAX-C (Utilidade) implantado em:", mauaxUtilityToken.address);

    // 3. MauaxRecyclingToken (MAUAX-R)
    const MauaxRecyclingToken = await hre.ethers.getContractFactory("MauaxRecyclingToken");
    const mauaxRecyclingToken = await MauaxRecyclingToken.deploy();
    await mauaxRecyclingToken.deployed();
    console.log("✅ Contrato MAUAX-R (Reciclagem) implantado em:", mauaxRecyclingToken.address);

    // 4. MauaxEnergyToken (MAUAX-E)
    const MauaxEnergyToken = await hre.ethers.getContractFactory("MauaxEnergyToken");
    const mauaxEnergyToken = await MauaxEnergyToken.deploy();
    await mauaxEnergyToken.deployed();
    console.log("✅ Contrato MAUAX-E (Energia) implantado em:", mauaxEnergyToken.address);

    console.log("\n--- [FASE 2/3] Implantando Contratos de Investimento (Security Tokens) ---");

    const MauaxSecurityToken = await hre.ethers.getContractFactory("MauaxSecurityToken");
    const MauaxGreenBondToken = await hre.ethers.getContractFactory("MauaxGreenBondToken");

    // 5. MAUAX-S (Solar)
    const mauaxSolarToken = await MauaxSecurityToken.deploy("MAUAX Solar Token", "MAUAX-S");
    await mauaxSolarToken.deployed();
    console.log("✅ Contrato MAUAX-S (Solar) implantado em:", mauaxSolarToken.address);

    // 6. MAUAX-D (Data)
    const mauaxDataToken = await MauaxSecurityToken.deploy("MAUAX Data Cloud Token", "MAUAX-D");
    await mauaxDataToken.deployed();
    console.log("✅ Contrato MAUAX-D (Data) implantado em:", mauaxDataToken.address);

    // 7. MAUAX-T (Tower)
    const mauaxTowerToken = await MauaxSecurityToken.deploy("MAUAX Tower Token", "MAUAX-T");
    await mauaxTowerToken.deployed();
    console.log("✅ Contrato MAUAX-T (Tower) implantado em:", mauaxTowerToken.address);

    // 8. MAUAX-B (Biopolo - como Green Bond)
    const maturityTimestamp = Math.floor(Date.now() / 1000) + (10 * 365 * 24 * 60 * 60); // Vencimento em 10 anos
    const couponRate = 500; // Representa 5.00%
    const mauaxBioBond = await MauaxGreenBondToken.deploy("MAUAX Biopolo Bond", "MAUAX-B", maturityTimestamp, couponRate);
    await mauaxBioBond.deployed();
    console.log("✅ Contrato MAUAX-B (Biopolo Bond) implantado em:", mauaxBioBond.address);

    console.log("\n--- [FASE 3/3] Sumário da Implantação ---");
    console.log("----------------------------------------------------");
    console.log("MAUAX-G (NFT):", mauaxFoundersNFT.address);
    console.log("MAUAX-C (Utilidade):", mauaxUtilityToken.address);
    console.log("MAUAX-R (Reciclagem):", mauaxRecyclingToken.address);
    console.log("MAUAX-E (Energia):", mauaxEnergyToken.address);
    console.log("----------------------------------------------------");
    console.log("MAUAX-S (Solar):", mauaxSolarToken.address);
    console.log("MAUAX-D (Data):", mauaxDataToken.address);
    console.log("MAUAX-T (Tower):", mauaxTowerToken.address);
    console.log("MAUAX-B (Biopolo Bond):", mauaxBioBond.address);
    console.log("----------------------------------------------------");

    console.log("\n🏁 Implantação completa de todos os contratos concluída!");
    console.log("➡️ Próximo passo: Execute '02-setup-governance.js' para transferir a propriedade de todos estes contratos para a Gnosis Safe.");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
