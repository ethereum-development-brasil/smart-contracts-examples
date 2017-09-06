pragma solidity ^0.4.13;

contract MyContract {
    
    uint myVariable;
    address owner;

    modifier onlyOwner() {
      if (owner == msg.sender) {
        _;
      } else {
        revert();
      }
    }

    function MyContract() payable {
        myVariable = 5;
        owner = msg.sender;
    }

    function setMyVariable(uint myNewVariable) onlyOwner {
        myVariable = myNewVariable;
    }

    function getMyVariable() constant returns (uint) {
        return myVariable;
    }
    
    function getMyContractBalance() constant returns(uint){
        return this.balance;
    }

    function kill() onlyOwner {
        selfdestruct(owner);
    }
    
    function() payable {
        
    }
}