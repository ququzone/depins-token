import * as fs from "fs";
import * as readline from 'readline';
import { parseAccountMap } from "./utils/parse-account-map";

async function main() {
    const data = [];
    const fileStream = fs.createReadStream("script/ts/data.csv");
    const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity,
    });
    for await (const line of rl) {
        const item = line.split(",");
        if (item[3] !== "0") {
            if (item[4] === "0x0aF8b31E2aB68a6F12088c7dc9AF829aeB4e31fc") {
                console.log(`contract amount: ${(BigInt(840000000) * BigInt("1000000000000000000")).toString()}`);
                continue;
            }
            // @ts-ignore
            data.push({account: item[4], amount: (BigInt(item[3]) * BigInt("1000000000000000000")).toString()});
        }
    }

    fs.writeFileSync("script/ts/data.json", JSON.stringify(data));
    const proof = parseAccountMap(data);
    fs.writeFileSync("script/ts/proof.json", JSON.stringify(proof));
}

main().catch(err => {
    console.error(err);
    process.exitCode = 1;
});


