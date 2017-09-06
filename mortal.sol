pragma solidity ^0.4.13;

contract Mortal {
    address owner;

    modifier onlyOwner() {
        if (owner == msg.sender) {
            _;
        } else {
            revert();
        }
    }

    function mortal() {
        owner = msg.sender;
    }

    function kill() onlyOwner {
        selfdestruct(owner);
    }
}