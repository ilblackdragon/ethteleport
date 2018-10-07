const ETHLock = artifacts.require("./ETHLock.sol");
const ETHToken = artifacts.require("./ETHToken.sol");

module.exports = async function(deployer) {
  deployer.deploy(ETHToken, "ETHToken", "ETHToken").then(function() {
      return deployer.deploy(ETHLock, ETHToken.address);
  }).then(function() { })
};
