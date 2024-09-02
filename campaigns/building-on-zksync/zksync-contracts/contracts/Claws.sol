//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Claws {
    address public creator;

    string _target;
    
    constructor () public {
        creator = msg.sender;
    }

    modifier onlyCreator() {
        require(msg.sender == owner, "Not the Contract creator!");
    }

    function slash(string memory _target) onlyCreator(){
        _target = "slashed";
    }

    function isSlashed(string memory _target) external view returns (bool) {
        if (_target == "slashed") {
            return true;
        } else {
            return false;
        }

    }
}
