pragma solidity ^0.4.0;

contract tirelire {

  string hello_world;
  uint public nbAcces;
  uint public objectif;
  address owner;

  constructor() public { 
	hello_world = "Bonjour je suis la tirelire";
	nbAcces = 0;
	objectif = 100000000000000000;
	owner = msg.sender;
  }

  function hello() constant returns (string) {
	return hello_world;
  }

  /* payable est un keyword reserve de solidity qui permet le transfert d ethers*/ 
  function donner() public payable { 
	nbAcces ++;
  }

  function retirer() public payable {
    nbAcces ++;
    assert(address(this).balance >= objectif);
    assert(msg.sender == owner);
    assert(msg.sender.send(address(this).balance));
  }

}
