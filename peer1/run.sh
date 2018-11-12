#!/bin/bash
uname=$(echo $(uname -a))
if [[ $uname =~ "Ubuntu" ]]; then
    geth --identity "BlockchainTP" --rpc --rpcport 8545 --datadir "~/.ethereum_example" --port 30306 --nodiscover --rpcapi "db,personal,eth,net,web3,debug" --rpccorsdomain="*" --ipcdisable --rpcaddr="localhost" --networkid 1999 console
elif [[ $uname =~ "Debian" ]]; then
    ./geth --identity "BlockchainTP" --rpc --rpcport 8545 --datadir "~/.ethereum_example" --port 30306 --nodiscover --rpcapi "db,personal,eth,net,web3,debug" --rpccorsdomain="*" --ipcdisable --rpcaddr="localhost" --networkid 1999 console
fi
