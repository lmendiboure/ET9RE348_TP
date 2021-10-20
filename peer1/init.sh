#!/bin/bash
geth --identity "BlockchainTP" --rpc --datadir "~/.ethereum_example" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 init "genesis.json"

