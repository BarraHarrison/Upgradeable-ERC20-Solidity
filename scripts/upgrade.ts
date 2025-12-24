import { ethers, upgrades } from "hardhat";

async function main() {
    const proxyAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

    const TokenV2 = await ethers.getContractFactory("UpgradeableTokenV2");

    console.log("Upgrading proxy…");

    const upgraded = await upgrades.upgradeProxy(proxyAddress, TokenV2);
    await upgraded.waitForDeployment();

    console.log("✅ Proxy upgraded");

    const implementation =
        await upgrades.erc1967.getImplementationAddress(proxyAddress);

    console.log("📦 New implementation:", implementation);

    const CAP = ethers.parseEther("1000000");
    await upgraded.initializeV2(CAP);

    console.log("Cap set to:", (await upgraded.cap()).toString());
    console.log("Token version:", await upgraded.version());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
