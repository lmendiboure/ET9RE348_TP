#!/bin/bash
uname=$(echo $(uname -a))
if [[ $uname =~ "Ubuntu" ]]; then
	geth --datadir "~/.ethereum_example" --password "./peer1/ethereum_pwd.txt" account new
elif [[ $uname =~ "Debian" ]]; then
	./geth --datadir "~/.ethereum_example" --password "./peer1/ethereum_pwd.txt" account new
fi

