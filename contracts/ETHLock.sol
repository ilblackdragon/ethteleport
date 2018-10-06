pragma solidity ^0.4.0;

contract ERC721Receiver {
    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
    function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
}

contract ETHLock is ERC721Receiver {
    function onERC721Received(address, uint256, bytes) public returns(bytes4) {
        return ERC721_RECEIVED;
    }
}
