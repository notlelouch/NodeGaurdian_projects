// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;  

import "./interfaces/IERC20.sol";  

/** 
 * @dev ERC-20 token contract.  
 */
contract Doubloon is IERC20 {  
    string public constant name = "Doubloon"; 
    string public constant symbol = "DBL"; 
    uint256 public totalSupply; 
    mapping(address => uint256) public balanceOf; 
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _supply) { 
        totalSupply = _supply; 
        balanceOf[msg.sender] = _supply; 
    } 
    
    function transfer(address _to, uint256 _amount) external returns (bool) { 
        require(balanceOf[msg.sender] >= _amount, "Insufficient funds"); 

        balanceOf[msg.sender] -= _amount; 
        balanceOf[_to] += _amount; 
        emit Transfer(msg.sender, _to, _amount);
        return true; 
    }
    
    function approve(address _spender, uint256 _amount) external returns (bool) { 
        allowance[msg.sender][_spender] = _amount; 
        emit Approval(msg.sender, _spender, _amount);
        return true; 
    } 
    
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool) { 
        require(balanceOf[_from] >= _amount, "Insufficient funds"); 
        require(allowance[_from][msg.sender] >= _amount, "Insufficient allowance"); 
        
        allowance[_from][msg.sender] -= _amount; 
        balanceOf[_from] -= _amount; 
        balanceOf[_to] += _amount; 
        emit Transfer(_from, _to, _amount);
        return true; 
    } 

}
