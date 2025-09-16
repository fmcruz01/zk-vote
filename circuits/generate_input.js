import * as circomlibjs from "circomlibjs";
import fs from "fs";

(async () => {
	const vote = BigInt(Math.floor(Math.random() * 2));
	const secret = BigInt("0x" + Buffer.from(crypto.getRandomValues(new Uint8Array(32))).toString("hex"));

	const poseidon = await circomlibjs.buildPoseidon();
	const commitmentBigInt = poseidon.F.toObject(poseidon([secret, vote]));
	const commitment = commitmentBigInt.toString();

	const input = {
		vote: vote.toString(),
		secret: secret.toString(),
		commitment: commitment
	};

	fs.writeFileSync("./input.json", JSON.stringify(input, null ,2));

})();
