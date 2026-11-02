// Pure scoring logic ported from the FoxPro procedure FX in BJFXPROC.PRG (1998).
// Unanswered questions fall back to weight 0 (N), matching the original's ESC behaviour.
const WEIGHTS = {N:0, F:1, G:2, O:4};

function scores(answers, data) {
  const sum = {}, cnt = {};
  data.forEach((r, i) => {
    sum[r.QZSX] = (sum[r.QZSX] || 0) + (WEIGHTS[answers[i]] || 0);
    cnt[r.QZSX] = (cnt[r.QZSX] || 0) + 1;
  });
  // normalise per group so larger groups are not favoured
  return Object.keys(sum).map(g => [g, sum[g] / cnt[g]]).sort((a, b) => b[1] - a[1]);
}

function analyse(answers, data) {
  const s = scores(answers, data);
  if (Math.abs(s[0][1] - s[1][1]) < 1e-9) return null; // tie for top
  return s[0][0];
}

if (typeof module !== "undefined" && module.exports) module.exports = {WEIGHTS, analyse, scores};
