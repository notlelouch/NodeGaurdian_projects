// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Doubloon.sol";

contract MintableDoubloon is Doubloon {
    address public owner;

    constructor(uint256 _supply) Doubloon(_supply) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can mint new tokens");
        _;
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
        emit Transfer(address(0), _to, _amount);
    }
}
