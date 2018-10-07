// Call this after:
// ETH Token is locked.
// The headers with the transaction was synced.

const EP  = require('eth-proof');
var rlp = require('rlp');
var BN = require('bn.js');
const Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

web3ify = (input) => {
  output = {};
  output.value = '0x' + rlp.encode(input.value).toString('hex');
  output.header = '0x' + rlp.encode(input.header).toString('hex');
  output.path = '0x00' + input.path.toString('hex');
  //output.path = (output.path.length%2==0 ? '0x00' : '0x1') + output.path
  output.parentNodes = '0x' + rlp.encode(input.parentNodes).toString('hex');
  output.txRoot = '0x' + input.header[4].toString('hex');
  output.blockHash = '0x' + input.blockHash.toString('hex');
  return output
};

// Load contract ABI
//const ETCToken_artifiacts = require('./ETCToken.abi');
//const contract = require('truffle-contract');
//const contract_inst = contract(ETCToken_artifiacts);
//console.log(contract_inst)

var fs = require('fs');
var jsonFile = "./cli/ETCToken.abi";
var parsed = JSON.parse(fs.readFileSync(jsonFile));
for (var i = 0; i < parsed.length; ++i) {
    console.log(parsed[i].name)
}
var abi = parsed.abi;

// Get the transaction.
var transaction = web3.eth.getTransaction('0xdb9a752bac7c6d5c6506ed37326fff5c4e819b9b5cb0ec1bfd74d1516b7b8d31');
//console.log(transaction);


var eP = new EP(new Web3.providers.HttpProvider("http://localhost:8545"));
eP.getTransactionProof(transaction.hash).then((proof)=>{
//    console.log("TRANSACTION PROOF");
//      console.log(proof);
    let wproof = web3ify(proof);
    let blockHash = new BN(wproof.blockHash).toString();
    // TODO: Invoke ETCToken with wproof and blockhash.
    //console.log(wproof.value);
    var ETCTokenInstance = web3.eth.contract(parsed.abi, '0xcd94168e5f9f8d7d77813c01a36f8a2c0128e51d')
    //var ETCToken = web3.eth.contract(abi);
    //var ETCTokenInstance = ETCToken.at('0xcd94168e5f9f8d7d77813c01a36f8a2c0128e51d')
    //console.log(ETCToken);
//    var ETCTokenInstance = contract_inst.at('0xcd94168e5f9f8d7d77813c01a36f8a2c0128e51d');
    data = ETCTokenInstance.mintUniqueTokenTo(wproof.value, blockHash,
                                        wproof.path, wproof.parentNodes);
//    console.log(wproof.value);
    }).catch((e)=>{
       console.log(e)
    });


// Command for generating ETCToken.abi:
// solcjs --abi /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol MerklePatriciaProof.sol Voting.sol ETCToken.sol RLP.sol /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721.sol /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/math/SafeMath.sol /Users/zaver/Projects/hackaton/testnet1/node_modules/zeppelin-solidity/contracts/AddressUtils.sol