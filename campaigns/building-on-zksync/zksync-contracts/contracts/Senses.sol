//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// TODO: Fix this contract

contract Senses {
    
    bytes enemyCode;

    constructor(address _firstEnemy) {
        enemyCode = _firstEnemy.code;
    }

    function detect(address _target) external view returns (bool) {  
        return (keccak256(_target.code) == keccak256(enemyCode));
    }

}

// The below contract will work because in zkEVM, only the hash of the contract's bytecode is accessible, 
// not the full bytecode itself.
// Instead of using the .code property, the codehash property is used to obtain the hash of the bytecode.

// contract Senses {
//
//     bytes32 enemyCodeHash;
//
//     constructor(address _firstEnemy) {
//         enemyCodeHash = _firstEnemy.codehash;
//     }
//
//     function detect(address _target) external view returns (bool) {  
//         return (_target.codehash == enemyCodeHash);
//     }
//
// }

