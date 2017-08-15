pragma solidity ^0.4.13;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract MyToken is owned {
  string public name;
  string public symbol;
  uint256 public totalSupply;
  uint8 public decimals;
  uint256 public sellPrice;
  uint256 public buyPrice;

  mapping (address => uint256) public balanceOf;
  mapping (address => bool) public frozenAccount;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event FrozenFunds(address target, bool frozen);

  function MyToken(
    uint256 initialSupply,
    string tokenName,
    string tokenSymbol,
    uint8 decimalUnits,
    address centralMinter) {
      totalSupply = initialSupply;
      name = tokenName;
      symbol = tokenSymbol;
      decimals = decimalUnits;
      if(centralMinter != 0) owner = centralMinter;
  }

  function transfer(address _to, uint256 _value) {
    if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to]) revert();

    if (frozenAccount[msg.sender]) revert();

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    Transfer(msg.sender, _to, _value);
  }

  function buy() payable returns (uint amount){
    amount = msg.value / buyPrice;                     // calculates the amount
    if (balanceOf[this] < amount) revert();            // checks if it has enough to sell
    balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
    balanceOf[this] -= amount;                         // subtracts amount from seller's balance
    Transfer(this, msg.sender, amount);                // execute an event reflecting the change
    return amount;                                     // ends function and returns
  }

  function sell(uint amount) returns (uint revenue){
    if (balanceOf[msg.sender] < amount ) revert();     // checks if the sender has enough to sell
    balanceOf[this] += amount;                         // adds the amount to owner's balance
    balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
    revenue = amount * sellPrice;
    if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
        revert();                                         // to do this last to prevent recursion attacks
    } else {
        Transfer(msg.sender, this, amount);             // executes an event reflecting on the change
        return revenue;                                 // ends function and returns
    }
  }

  function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
    sellPrice = newSellPrice;
    buyPrice = newBuyPrice;
  }
  
  function mintToken(address target, uint256 mintedAmount) onlyOwner {
    balanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, owner, mintedAmount);
    Transfer(owner, target, mintedAmount);
  }

  function freezeAccount(address target, bool freeze) onlyOwner {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
  }
}