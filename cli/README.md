# Requirements
Install solidity compiler:
https://solidity.readthedocs.io/en/latest/installing-solidity.html#binary-packages


Make sure you are running Node.js 8:
```
sudo n 8
```

Install web3 and eth-proof packages globally:
```
npm install -g web3
npm install -g eth-proof
npm install -g bn.js
```

# Running minter
```bash
export NODE_PATH=/usr/local/lib/node_modules
node cli/minter.js
```