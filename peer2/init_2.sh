geth --identity "BlockchainTP" --rpc --datadir "~/.ethereum_example_2" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 init "../genesis.json"
cp mineWhenNeeded.js ~/.ethereum_example_2/
cp minedBlocks.js ~/.ethereum_example_2/
