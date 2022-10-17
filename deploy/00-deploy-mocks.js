const { network } = require("hardhat")
const {
    developmentChains,
    DECIMALS,
    INITIAL_ANSWER,
} = require("../helper-hardhat-config")

//we use a mock script to test in a local host environment, because local hosts cannot connect to a testnet blockchain
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    if (developmentChains.includes(network.name)) {
        log("local network detected: Deploying mocks...")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true, //will give us extra information on deployment (gas used, etc)
            args: [DECIMALS, INITIAL_ANSWER],
        })
        log("Mocks deployed!")
        log("-------------------------------------------")
    }
}

//choose whether to deploy mocks or all (yarn hardhat deploy --tags mocks)
module.exports.tags = ["all", "fundme"]
