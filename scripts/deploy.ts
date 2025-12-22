import { ethers, upgrades } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with account:", deployer.address);
    console.log("Deployer balance:", (await deployer.provider.getBalance(deployer.address)).toString());

    const TokenV1 = await ethers.getContractFactory("UpgradeableTokenV1");

    const proxy = await upgrades.deployProxy(
        TokenV1,
        [
            "Upgradeable Token",
            "UPTK",
            deployer.address,
        ],
        {
            kind: "uups",
            initializer: "initializer",
        }
    );

    await proxy.waitForDeployment();

    const proxyAddress = await proxy.getAddress();
    const implementationAddress =
        await upgrades.erc1967.getImplementationAddress(proxyAddress);

    console.log("\n✅ Proxy deployed at:", proxyAddress);
    console.log("📦 Implementation deployed at:", implementationAddress);

    console.log("Token name:", await proxy.name());
    console.log("Token symbol:", await proxy.symbol());
    console.log("Token version:", await proxy.version());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});