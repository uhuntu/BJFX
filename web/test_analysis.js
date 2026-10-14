// Tests for analysis.js and the bjfx_data.json schema. Run: node test_analysis.js
const assert = require("assert");
const fs = require("fs");
const path = require("path");
const {WEIGHTS, analyse} = require("./analysis.js");

// weights match the 1998 design (BJFXSJ.TXT)
assert.deepStrictEqual(WEIGHTS, {N: 0, F: 1, G: 2, O: 4});

const D = [
  {QZSX: "DZ"}, {QZSX: "DZ"}, {QZSX: "DZ"}, {QZSX: "NY"},
];

// clearest answer wins
assert.strictEqual(analyse(["O", "N", "N", "N"], D), "DZ");
assert.strictEqual(analyse(["N", "N", "N", "O"], D), "NY");

// per-group normalisation: DZ raw sum 3 (avg 1) loses to NY raw sum 2 (avg 2)
assert.strictEqual(analyse(["F", "F", "F", "G"], D), "NY");

// tie for the top -> analysis fails (null), as in the original
assert.strictEqual(analyse(["N", "N", "N", "N"], D), null);
assert.strictEqual(analyse(["F", "F", "F", "F"], D), null);

// unanswered counts as N, matching the original's ESC-to-end behaviour
assert.strictEqual(analyse(["G", undefined, undefined, "N"], D), "DZ");
assert.strictEqual(analyse([undefined, undefined, undefined, "F"], D), "NY");

// real data: schema stays clean
const data = JSON.parse(fs.readFileSync(path.join(__dirname, "..", "bjfx_data.json"), "utf8"));
assert.strictEqual(data.length, 63);
const groups = new Set(["DZ", "YY", "NY", "DX"]);
for (const r of data) {
  assert.deepStrictEqual(Object.keys(r).sort(), ["DYXG", "QZSX", "ZJTD"]);
  assert.ok(groups.has(r.QZSX), "unexpected QZSX " + r.QZSX);
  assert.ok(!/\s/.test(r.ZJTD), "whitespace in ZJTD: " + r.ZJTD);
  assert.ok(!/\s/.test(r.DYXG), "whitespace in DYXG: " + r.DYXG);
}

// full run on the real knowledge base returns a valid verdict
const win = analyse(data.map((_, i) => ["N", "F", "G", "O"][i % 4]), data);
assert.ok(win === null || groups.has(win), "unexpected winner " + win);
console.log("full-data sample verdict:", win);

console.log("all tests passed");
