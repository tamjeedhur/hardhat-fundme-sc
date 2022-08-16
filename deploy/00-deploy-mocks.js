const {
    developmentChains,
    DECIMALS,
    INITIAL_ANSWERS,
} = require("../helper-hardhat-config")
const { network } = require("hardhat")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    console.log(network.name)
    if (developmentChains.includes(network.name)) {
        log("Local network detected! Deploying mocks ...")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [DECIMALS, INITIAL_ANSWERS],
        })
        log("mock deployed !")
        log("-----------------------------------------------")
    }
}

module.exports.tags = ["all", "mocks"]
