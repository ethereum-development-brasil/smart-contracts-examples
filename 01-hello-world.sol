pragma solidity ^0.4.0;

contract HelloWorld{
  string word = "Hello World";

  function getWord() constant returns(string){
    return word;
  }

  function setWord(string newWord){
    word = newWord;
  }
}