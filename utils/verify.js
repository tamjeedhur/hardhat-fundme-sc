const { run } = require("hardhat")

const verify = async (contractAddress, args) => {
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (error) {
        if (error.message.toLowerCase().includes("already verified!")) {
            console.log("already verified!")
        } else {
            console.log(error.message)
        }
    }
}

module.exports = {
    verify,
}
