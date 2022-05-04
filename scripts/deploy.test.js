const { ethers } = require("hardhat");

async function main() {
    const SbitNFT = await ethers.getContractFactory("SbitNFT");
    const sbitNFT = await SbitNFT.deploy();
    await sbitNFT.deployed();
    console.log(sbitNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });