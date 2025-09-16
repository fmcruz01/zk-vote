pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

// This circuit proves that a give vote is a valid vote
template VoteCheck() {

	signal input vote; // private input (vote)
	signal input secret; // private input (for commitment)
	signal input commitment; // public input (registered commitment)
	signal output outCommitment; // public output

	// Enforce binary vote (either 0 or 1)
	vote * (1 - vote) === 0;
	
	// Compute Poseidon(secret, vote) hash
	component hash = Poseidon(2);
	hash.inputs[0] <== secret;
	hash.inputs[1] <== vote;
	
	
	// Enforce commitment matches hash(secret, vote);
	hash.out === commitment;

	outCommitment <== hash.out;
}

component main { public [commitment]} = VoteCheck();
