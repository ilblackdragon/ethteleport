const MinimalERC721 = artifacts.require("./MinimalERC721.sol");

module.exports = async function(deployer) {
  await deployer.deploy(MinimalERC721, "MinimalERC721", "MinimalERC721")
  const erc721 = await MinimalERC721.deployed()
};
