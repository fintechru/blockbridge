const { expect } = require("chai");

describe("Mastermost", function () {
    it("Should return total supply if deploy successful", async function () {
        const Mastermost = await ethers.getContractFactory("Mastermost");
        const mastermost = await Mastermost.deploy();
        await mastermost.deployed();

        expect(await mastermost.totalSupply()).to.equal(1000);
    });

    it("Should return total supply if deploy successful", async function () {
        const Mastermost = await ethers.getContractFactory("Mastermost");
        const mastermost = await Mastermost.deploy();
        await mastermost.deployed();

        expect(await mastermost.totalSupply()).to.equal(1000);
    });
});
