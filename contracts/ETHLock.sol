pragma solidity ^0.4.22;

import "./ETHToken.sol";

contract ETHLock {

    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
    event Locked(address owner, uint256 tokenId, bytes data);
    event Transfer(address sender, uint256 tokenId);

    address ethTokenAddress;

    constructor(address _ethTokenAddress) public {
        ethTokenAddress = _ethTokenAddress;
    }

    function onERC721Received(address owner, uint256 tokenId, bytes data) public returns(bytes4) {
        emit Locked(owner, tokenId, data);
        return ERC721_RECEIVED;
    }

    function lock(uint256 tokenId) public {
        emit Transfer(msg.sender, tokenId);
        ETHToken ethToken = ETHToken(ethTokenAddress);
        ethToken.transferFrom(msg.sender, this, tokenId);
    }
}
