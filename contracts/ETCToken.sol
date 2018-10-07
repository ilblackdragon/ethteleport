pragma solidity ^0.4.23;

import "../node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "./MerklePatriciaProof.sol";
import "./Voting.sol";

contract ETCToken is ERC721Token {
    event TxRootEvent(bytes32 txRoot);
    address votingAddress;
    constructor (address _votingAddress, string _name, string _symbol) public
        ERC721Token(_name, _symbol)
    {
        votingAddress = _votingAddress;
    }

    function stringToBytes32(string memory source) returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function trieValue(bytes value, bytes encodedPath, bytes parentNodes, bytes32 root) constant internal returns (bool) {
        return MerklePatriciaProof.verify(value, encodedPath, parentNodes, root);
    }

    function checkTxProof(bytes value, uint256 blockHash, string blockIndex, bytes path, bytes parentNodes) constant returns (bool) {
        // add fee for checking transaction
        Voting voting = Voting(votingAddress);
        var (txRoot, isLocked) = voting.get(blockIndex);
        if (isLocked) {
            bytes32 btxRoot = stringToBytes32(txRoot);
            emit TxRootEvent(btxRoot);
            return trieValue(value, path, parentNodes, btxRoot);
        }
    }


    function mintUniqueTokenTo(
        address _to,
        uint256 _tokenId,
        string  _tokenURI,
        bytes value,
        uint256 blockHash,
        string blockIndex,
        bytes path,
        bytes parentNodes) public
    {
        if (checkTxProof(value, blockHash, blockIndex, path, parentNodes)) {
            super._mint(_to, _tokenId);
            super._setTokenURI(_tokenId, _tokenURI);
        }
    }
}
