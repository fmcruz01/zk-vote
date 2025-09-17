# Zkvote

[![CI](https://github.com/fmcruz01/zk-vote/actions/workflows/Build.yml/badge.svg?branch=main&event=push)](https://github.com/fmcruz01/zk-vote/actions/workflows/Build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)

A simple decentralized application that explores how **zero-knowledge proofs (zk-SNARKs)** can be applied to a real-world use case: **anonymous and verifiable voting**.  

My main goal with this project is to **learn and understand how zero-knowledge proofs work** and how they can be used in practice, while also improving my Solidity and Frontend development skills.

---

## 🚀 Getting Started

### Install dependencies

```bash
npm install
```

### Compile contracts and run tests

```bash
npm run build
```

## Creating voting data file, creating circuit and verifier contract.

### Generate input file

```bash
node ./ciircuits/generate_input.json
```

### Building circuit using circom

```bash
circom ./circuits/vote.circom --r1cs --wasm --sym -o ./circuits/build
```

### Starting powers of tau ceremony

```bash
snarkjs groth16 setup ./circuits/build/vote.r1cs powersOfTau28_hez_final_19.ptau ./circuits/build/vote_0000.zkey
```

### Contributing for PoT ceremony

```bash
snarkjs zkey contribute ./circuits/build/vote_0000.zkey ./circuits/build/vote_final.zkey
```

### Generate verification key

```bash
snarkjs zkey export verificationkey ./circuits/build/vote_final.zkey ./circuits/build/verification_key.json
```

### Generate Verifier solidity contract

```bash
snarkjs zkesv ./circuits/build/vote_final.zkey ./contracts/Verifier.sol
```

### Generate witness

Before running the command, make sure to rename both 'generate_witness.js' and 'witness_calculator.js' files extension to '.cjs' so it is compatible with Hardhat 3 ES module. Also rename the import inside 'generate_witness.cjs'.

```bash
node ./circuits/build/vote_js/generate_witness.cjs ./circuits/build/vote_js/vote.wasm ./circuits/input.json ./circuits/witness.wtns
```

### Generate proof

```bash
snarkjs groth16 prove ./circuits/build/vote_final.zkey ./circuits/witness.wtns ./circuits/proof.json ./circuits/public.json
```

### Verify proof using cli

```bash
snarkjs groth16 verify ./circuits/build/verification_key.json ./circuits/public.json ./circuits/proof.json
```
