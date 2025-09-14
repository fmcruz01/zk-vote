#!/usr/bin/env sh
set -e

npx hardhat compile
prettier --plugin node_modules/prettier-plugin-solidity/src/index.js --check '(contracts|test)/**/*.(js|sol)'
