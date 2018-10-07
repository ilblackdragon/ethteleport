const ETHLock = artifacts.require("./ETHLock.sol");
const ETHToken = artifacts.require("./ETHToken.sol");
const ETCToken = artifacts.require("./ETCToken.sol");
const Voting = artifacts.require("./Voting.sol");

module.exports = async function(deployer) {
  deployer.deploy(ETHToken, "ETHToken", "ETHToken").then(function() {
      return deployer.deploy(ETHLock, ETHToken.address);
  }).then(function() {
      return deployer.deploy(Voting, "Voting", "Voting");
  }).then(function() {
          return deployer.deploy(ETCToken, Voting.address, "ETCToken", "ETCToken");
      })
};
