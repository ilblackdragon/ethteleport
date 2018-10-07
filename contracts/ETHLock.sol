pragma solidity ^0.4.22;

contract ERC721Receiver {
    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
    function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
}

contract ETHLock is ERC721Receiver {
    event Locked(address owner, uint256 tokenId, bytes data);

    function onERC721Received(address owner, uint256 tokenId, bytes data) public returns(bytes4) {
        emit Locked(owner, tokenId, data);
        return ERC721_RECEIVED;
    }
}
