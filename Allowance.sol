pragma solidity ^0.6.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol"; // Calling Solidity function from OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol"; // Calling Safemath for functions

contract Allowance is Ownable { // is Ownable extends
    
    using SafeMath for uint; // Safemath is used for importing mathematical funcitons in solidity
    
    event AllowanceChanged ( address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount); // changing the allowance given 
    
    // _amount => is a parameter passed into the function. that's why _ before the parameter
    
    function isOwner() internal view returns(bool) { // to verify the owner // internal only available in this contract and contracts which extend this contract
        return owner() == msg.sender;
    }
    
    mapping(address => uint) public allowance;  // value of address is mapped to an unsigned integer which is also public to other functions
    
    function addAllowance (address _who, uint _amount) public { // giving allowance to the Patient/ Employee/ Child
        emit AllowanceChanged (_who, msg.sender, allowance[_who], _amount); // it is used to emit the event if the transaction is also performed
        allowance[_who] = _amount; // transferring the amount.
    }
    
    modifier ownerOrAllowed(uint _amount) {  // it allows to control the behavior of a smart contract function.. Usability improve.. check pre-conditions
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed"); 
        _; // is just a notation to show that above line will be used as a function wherever this modifier is called.
    }
    
    function reduceAllowance (address _who, uint _amount) internal {         //protected
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));  // sub function used from Safe Math
        allowance[_who] = allowance[_who].sub( _amount); // Safe Math used
    }
}
