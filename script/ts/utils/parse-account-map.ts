import { isAddress, getAddress } from "ethers"
import AccountTree from "./account-tree"

// This is the blob that gets distributed and pinned to IPFS.
// It is completely sufficient for recreating the entire merkle tree.
// Anyone can verify that all air drops are included in the tree,
// and the tree has no additional distributions.
interface MerkleDistributorInfo {
    merkleRoot: string
    claims: {
        [account: string]: {
            index: number
            proof: string[]
        }
    }
}

export function parseAccountMap(whitelist: {account: string, amount: string}[]): MerkleDistributorInfo {
    const dataByAddress = whitelist.reduce<{ [address: string]: {account: string, amount: BigInt} }>((memo, {account, amount}) => {
        if (!isAddress(account)) {
            console.log(account);
            throw new Error(`Found invalid address: ${account}`)
        }
        const parsed = getAddress(account)
        if (memo[parsed]) throw new Error(`Duplicate address: ${parsed}`)

        memo[parsed] = {account: account, amount: BigInt(amount)}
        return memo
    }, {})

    const sortedAddresses = Object.keys(dataByAddress).sort()

    // construct a tree
    const tree = new AccountTree(sortedAddresses.map((address) => ({ account: address, amount:  dataByAddress[address].amount})))

    // generate claims
    const claims = sortedAddresses.reduce<{
        [address: string]: { index: number; amount: string, proof: string[] }
    }>((memo, address, index) => {
        memo[address] = {
            index,
            amount: dataByAddress[address].amount.toString(),
            proof: tree.getProof(address, dataByAddress[address].amount),
        }
        return memo
    }, {})

    return {
        merkleRoot: tree.getHexRoot(),
        claims,
    }
}
