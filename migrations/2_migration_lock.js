const ETHLock = artifacts.require("./ETHLock.sol");

module.exports = async function(deployer) {
  await deployer.deploy(ETHLock, "ETHLock", "ETHLock");
  const ethlock = await ETHLock.deployed();
};
