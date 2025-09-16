import fs from "fs";
import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

describe("Zkvote registerVote(Proof proof)", function () {
	it("Should register vote if the proof given matches the commitment", async function () {
		const [user] = await ethers.getSigners();
		const verifier = await ethers.deployContract("Groth16Verifier");
		const zkvote = await ethers.deployContract("Zkvote", [verifier.getAddress()]);
		
		const votingData = JSON.parse(fs.readFileSync("/home/kiko/Projects/zk-vote/circuits/input.json"));
		const proof = JSON.parse(fs.readFileSync("/home/kiko/Projects/zk-vote/circuits/proof.json"));
		const publicInput = JSON.parse(fs.readFileSync("/home/kiko/Projects/zk-vote/circuits/public.json"));
		
		const calldata = {
			a: [BigInt(proof.pi_a[0]), BigInt(proof.pi_a[1])],
			b: [
				[BigInt(proof.pi_b[0][1]), BigInt(proof.pi_b[0][0])],
				[BigInt(proof.pi_b[1][1]), BigInt(proof.pi_b[1][0])]
			],
			c: [BigInt(proof.pi_c[0]), BigInt(proof.pi_c[1])],
			input: publicInput.map(BigInt)
		};
		
		await zkvote.connect(user).registerVoter(BigInt(votingData.commitment));
		
		await zkvote.connect(user).submitVote(calldata);

		expect(await zkvote.hasVoted(user)).to.equal(true);
	});
});
