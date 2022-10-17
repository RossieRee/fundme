const { inputToConfig } = require("@ethereum-waffle/compiler")
const { deployments, ethers, getNamedAccounts } = require("hardhat")
const { developmentChains } = require("../../helper-hardhat-config")
const { assert } = require("chai")

describe("FundMe", async function () {
    let fundMe
    let deployer
    let mockV3Aggregator
    beforeEach(async function () {
        // deploy our fundMe contract
        // using Hardhat-deploy
        deployer = (await getNamedAccounts()).deployer
        deployments.fixture(["all"]) //deploys everything in deploy folder... like tags
        fundMe = await ethers.getContract("FundMe", deployer) //gets most recent deployed "FundMe" contract
        mockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )
    })
    describe("constructor", async function () {
        it("set the aggregator addresses correctly", async function () {
            const response = await fundMe.pricefeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })
})
