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
var fs = require('fs');
var jsonFile = "./cli/erc721.abi.json";
var parsed = JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;

// Get the transaction.
var transaction = web3.eth.getTransaction('0xa601c63b2d2083e464640a201eec0f385cf832d48280c9325b3cccf0e7423fc4');
//console.log(transaction);


var eP = new EP(new Web3.providers.HttpProvider("http://localhost:8545"));
eP.getTransactionProof(transaction.hash).then((proof)=>{
//    console.log("TRANSACTION PROOF");
//      console.log(proof);
    let wproof = web3ify(proof);
    let blockHash = new BN(proof.blockHash).toString();
    // TODO: Invoke ETCToken with wproof and blockhash.
    console.log(wproof.value);
    // data = ETCToken.mint.getData(txProof.value, blockHash,
    //                                 txProof.path, txProof.parentNodes)

    }).catch((e)=>{console.log(e)});
