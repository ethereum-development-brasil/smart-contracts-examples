pragma solidity ^0.4.13;

contract MyToken {
  string public name;
  string public symbol;
  uint8 public decimals;

  mapping (address => uint256) public balanceOf;

  event Transfer (address indexed from, address indexed to, uint256 value);
  
  function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) {
    if (initialSupply == 0) initialSupply = 1000000;
    balanceOf[msg.sender] = initialSupply;
    name = tokenName;
    symbol = tokenSymbol;
    decimals = decimalUnits;
  }

  function trnsfer(address _to, uint256 _value) {
    if (balanceOf[msg.sender] < _value) revert();
    if (balanceOf[_to] + _value < balanceOf[_to]) revert();
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    Transfer(msg.sender, _to, _value);
  }
}