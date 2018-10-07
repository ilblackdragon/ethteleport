const ETHToken = artifacts.require("./ETHToken.sol");

module.exports = async function(deployer) {
  await deployer.deploy(ETHToken, "ETHToken", "ETHToken");
  const ethtoken = await ETHToken.deployed();
};
