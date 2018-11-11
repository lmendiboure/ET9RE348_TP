geth --identity "BlockchainTP" --rpc --rpcport 8545 --datadir "~/.ethereum_example" --port 30306 --nodiscover --rpcapi "db,personal,eth,net,web3,debug" --rpccorsdomain="*" --ipcdisable --rpcaddr="localhost" --networkid 1999 console


#geth --datadir ./datadir_new --networkid 2018 --port 30306 --nodiscover --rpc --rpcapi "db,personal,eth,net,web3,debug" --rpccorsdomain="*" --rpcaddr="localhost" --rpcport 8545 console
