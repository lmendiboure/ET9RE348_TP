function minedBlocks() {
  addrs = [];
  limit = eth.blockNumber - 10
  for (i=0; i <= eth.blockNumber; i++) {
      console.log("\n\nBlock number : ", i, "\n")
      console.log(JSON.stringify(eth.getBlock(i), null, 4)); 
  }
  return addrs
}

minedBlocks();
