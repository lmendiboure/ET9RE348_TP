#!/bin/bash
geth --identity "BlockchainTP" --rpc --rpcport 8546 --datadir "~/.ethereum_example_2" --port 30307 --nodiscover --rpcapi "db,personal,eth,net,web3,debug" --rpccorsdomain="*" --ipcdisable --rpcaddr="localhost" --networkid 1999 console 

