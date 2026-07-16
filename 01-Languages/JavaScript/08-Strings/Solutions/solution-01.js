// solution-01.js - slug generator built entirely from chained string transformations.

function slugify(title) {
  return title
    .trim()
    .toLowerCase()
    .replace(/\s+/g, "-")        // any run of whitespace -> single hyphen
    .replace(/[^a-z0-9-]/g, "")  // strip anything that isn't a lowercase letter, digit, or hyphen
    .replace(/-+/g, "-")         // collapse multiple hyphens into one
    .replace(/^-+|-+$/g, "");    // strip leading/trailing hyphens
}

console.log(slugify("  Hello, World!  "));
console.log(slugify("What's New in JavaScript 2026?"));
console.log(slugify("---Already---Hyphenated---"));
