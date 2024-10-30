import MerkleTree from "./merkle-tree"
import { solidityPackedKeccak256 } from "ethers"

export default class AccountTree {
    private readonly tree: MerkleTree
    constructor(accounts: { account: string, amount: BigInt }[]) {
        this.tree = new MerkleTree(
            accounts.map(({ account, amount }) => {
                return AccountTree.toNode(account, amount)
            })
        )
    }

    public static verifyProof(
        account: string,
        amount: BigInt,
        proof: Buffer[],
        root: Buffer
    ): boolean {
        let pair = AccountTree.toNode(account, amount)
        for (const item of proof) {
            pair = MerkleTree.combinedHash(pair, item)
        }

        return pair.equals(root)
    }

    // keccak256(abi.encode(index, account))
    public static toNode(account: string, amount: BigInt): Buffer {
        return Buffer.from(
            solidityPackedKeccak256(["address", "uint256"], [account, amount]).slice(2),
            "hex"
        )
    }

    public getHexRoot(): string {
        return this.tree.getHexRoot()
    }

    // returns the hex bytes32 values of the proof
    public getProof(account: string, amount: BigInt): string[] {
        return this.tree.getHexProof(AccountTree.toNode(account, amount))
    }
}
