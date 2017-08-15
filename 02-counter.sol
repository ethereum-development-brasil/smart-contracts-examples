pragma solidity ^0.4.13;

contract Counter{
  uint counter = 0;

  function increase() {
    counter++;
  }

  function decrease() {
    counter--;
  }

  function getCounter() constant returns(uint) {
    return counter;
  }
}