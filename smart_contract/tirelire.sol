pragma solidity ^0.4.0;

contract tirelire {

  string hello_world;

  constructor() public {
	 hello_world = "Bonjour je suis la tirelire";
  }

  function hello() constant returns (string) {
	 return hello_world;
  }

  /* payable est un keyword reserve de solidity qui permet le transfert d ethers*/
  function donner() public payable {

  }

  function retirer() public payable {
    assert(msg.sender.send(address(this).balance));
  }

}


