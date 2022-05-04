const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SbitNFT", function() {
    it("Should return the new sbit nft once it's changed", async function() {
        const SbitNFT = await ethers.getContractFactory("SbitNFT");
        const sbitNFT = await SbitNFT.deploy();

        await sbitNFT.deployed();
        const res = await sbitNFT.createNFTItem(
            "cat",
            "https://bashupload.com",
            "cat",
            10
        );
        const r1 = await sbitNFT.getNFTInfoById(0);
        console.log(r1);
    });
});