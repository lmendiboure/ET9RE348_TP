#!/bin/bash


      # First of all, go needs to be installed

      sudo apt-get update
      mkdir go_install
      cd go_install
      wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
      tar -xvf go1.10.3.linux-amd64.tar.gz
      sudo mv go /usr/local
      export GOROOT=/usr/local/go
      export GOPATH=$(pwd)
      export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

      # Build essential, gcc, make 

      sudo apt-get install build-essential

      #/usr/local/go/bin/go get -d github.com/ethereum/go-ethereum
      #/usr/local/go/bin/go install github.com/ethereum/go-ethereum/cmd/geth

      cd ..
      sudo rm -r go_install 

      # Then, geth needs to be installed

      git clone https://github.com/ethereum/go-ethereum.git --branch release/1.8
      cd go-ethereum
      make geth
      cp build/bin/geth ..
      cd ..
      sudo rm -r go-ethereum

