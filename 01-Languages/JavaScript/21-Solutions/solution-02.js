// solution-02.js - Word Frequency Counter
// See: ../20-Exercises/README.md#exercise-02--word-frequency-counter-beginnerintermediate
//
// Run with:
//   node solution-02.js

function wordFrequencies(text) {
  // A single regex strips exactly the punctuation this exercise cares about
  // rather than chaining several .replace() calls, one per character.
  const cleaned = text.toLowerCase().replace(/[.,!?]/g, "");
  const words = cleaned.split(/\s+/).filter((w) => w.length > 0);

  const counts = {};
  for (const word of words) {
    // "?? 0" rather than "|| 0" matters in general (0 is falsy but a
    // legitimate count) - here it's moot since counts start at 1, but it's
    // the habit that avoids a real bug once a count could legitimately be 0.
    counts[word] = (counts[word] ?? 0) + 1;
  }
  return counts;
}

console.log(wordFrequencies("The cat sat. The cat ran!"));
