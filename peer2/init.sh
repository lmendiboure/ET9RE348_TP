#!/bin/bash
uname=$(echo $(uname -a))
if [[ $uname =~ "Ubuntu" ]]; then
    geth --identity "BlockchainTP" --rpc --datadir "~/.ethereum_example_2" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 init "genesis.json"
elif [[ $uname =~ "Debian" ]]; then
    ./geth --identity "BlockchainTP" --rpc --datadir "~/.ethereum_example_2" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 init "genesis.json"
fi
