const Voting = artifacts.require("./Voting.sol");

module.exports = async function(deployer) {
  await deployer.deploy(Voting, "Voting", "Voting");
  const voting = await Voting.deployed();
};
