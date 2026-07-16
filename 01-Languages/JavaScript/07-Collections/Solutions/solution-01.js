// solution-01.js - word frequency counting with Map, then ranking with sort/slice.

function wordFrequency(text) {
  const counts = new Map();
  const words = text
    .toLowerCase()
    .replace(/[.,!?]/g, "")   // strip basic punctuation before splitting
    .split(/\s+/)
    .filter(Boolean);          // drop any empty strings from extra whitespace

  for (const word of words) {
    counts.set(word, (counts.get(word) ?? 0) + 1);
  }
  return counts;
}

function topN(frequencyMap, n) {
  return Array.from(frequencyMap.entries())
    .sort((a, b) => {
      if (b[1] !== a[1]) return b[1] - a[1]; // higher count first
      return a[0].localeCompare(b[0]);        // tie-break alphabetically
    })
    .slice(0, n);
}

const freq = wordFrequency("Cats, cats, and dogs. Dogs love cats!");
console.log(topN(freq, 2));
console.log("Full frequency map:", freq);
