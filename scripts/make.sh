#!/usr/bin/env sh
set -e

npx hardhat compile
prettier --plugin node_modules/prettier-plugin-solidity/src/index.js --write '(contracts|test)/**/*.(js|sol)'
solhint  -f table contracts/**/*.sol

npx hardhat test 
