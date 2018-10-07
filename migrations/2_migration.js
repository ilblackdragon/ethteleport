const ETHToken = artifacts.require("./ETHToken.sol");
const ETHLock = artifacts.require("./ETHLock.sol");
const Voting = artifacts.require("./Voting.sol");

module.exports = async function(deployer) {
  await deployer.deploy(ETHToken, "ETHToken", "ETHToken");
  const ethtoken = await ETHToken.deployed();

  await deployer.deploy(ETHLock, "ETHLock", "ETHLock");
  const ethlock = await ETHLock.deployed();

  await deployer.deploy(Voting, "Voting", "Voting");
  const voting = await Voting.deployed();
};
