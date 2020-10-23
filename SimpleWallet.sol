pragma solidity ^0.6.1;

import "./Allowance.sol";

contract SharedWallet is Allowance { // Extends

    event MoneySent(address _beneficiary, uint _amount);  // 1
    event MoneyReceived(address indexed _from, uint _amount); // 2
    
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) { // called from modifier ownerOrAllowed in file Allowance.sol 
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount); // called from 1
        _to.transfer(_amount); 
    }
    
    // function renounceOwnership() public onlyOwner {
    //     revert("can't renounceOwnership here"); //not possible with this smart contract
    // }
    
    receive () external payable { // external - only available externally and not internally.
        emit MoneyReceived(msg.sender, msg.value); // called from 2
    }
}
