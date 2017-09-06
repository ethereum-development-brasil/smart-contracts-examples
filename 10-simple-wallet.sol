pragma solidity ^0.4.13;

// import "github.com/ethereum/solidity/std/mortal.sol";
import "mortal.sol";

contract SympleWallet is Mortal {
    
    mapping(address => Permission) allowedAddresses;

    event SomeoneAddedSomeoneToTheSendersList(address theAddressWhoAdded, address thePersonWhoIsAllowed, uint thisMuchHeCanSpend);
    
    event SomeoneRemovedSomeoneFromTheSendersList(address theAddressWhoRemove, address theRemovedAddress);
    
    event SomeoneSendFunds(address theSender, address theReceiver, uint amountInWei);

    struct Permission {
        bool isAllowed;
        uint maxTransferAmount;
    }
    
    function isAllowed(address someAddress) constant returns (bool) {
        return allowedAddresses[someAddress].isAllowed;
    }

    function addAddressToSendersList(address allowedAddress, uint maxTransferAmount) onlyOwner {
        allowedAddresses[allowedAddress] = Permission(true, maxTransferAmount);
        SomeoneAddedSomeoneToTheSendersList(msg.sender, allowedAddress, maxTransferAmount);
    }

    function removeAddressFromSendersList(address bannedAddress) onlyOwner {
        delete allowedAddresses[bannedAddress];
        SomeoneRemovedSomeoneFromTheSendersList(msg.sender, bannedAddress);
    }

    function sendFunds(address receiver, uint amountInWei) {
        if (allowedAddresses[msg.sender].isAllowed) {
            if (allowedAddresses[msg.sender].maxTransferAmount >= amountInWei) {
                bool isTheAmountReallySent = receiver.send(amountInWei);
                if (!isTheAmountReallySent) {
                    revert();
                } else {
                    SomeoneSendFunds(msg.sender, receiver, amountInWei);
                }
            } else {
                revert();
            }
        } else {
            revert();
        }
    }
    
    function() payable {
    }
}