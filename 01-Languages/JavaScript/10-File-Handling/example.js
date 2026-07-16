// example.js - reading/writing text and JSON files with fs/promises, and the ENOENT pattern.
// Uses require() (CommonJS) since this file has no package.json declaring "type": "module";
// Lesson 15 covers the CommonJS vs. ES module distinction in depth.

const { readFile, writeFile, unlink } = require("node:fs/promises");
const path = require("node:path");

const textPath = path.join(__dirname, "notes.txt");
const configPath = path.join(__dirname, "config.json");
const missingPath = path.join(__dirname, "does-not-exist.json");

async function loadOrDefault(filePath, defaultValue) {
  try {
    const raw = await readFile(filePath, "utf8");
    return JSON.parse(raw);
  } catch (err) {
    if (err.code === "ENOENT") {
      return defaultValue;
    }
    throw err;
  }
}

async function main() {
  console.log("--- text file round-trip ---");
  await writeFile(textPath, "Hello, file system!\n", "utf8");
  const textContents = await readFile(textPath, "utf8");
  console.log("Read back:", JSON.stringify(textContents));

  console.log("\n--- JSON file round-trip ---");
  const config = { theme: "dark", fontSize: 14 };
  await writeFile(configPath, JSON.stringify(config, null, 2), "utf8");
  const rawConfig = await readFile(configPath, "utf8");
  console.log("Round-tripped config:", JSON.parse(rawConfig));

  console.log("\n--- ENOENT pattern on a genuinely missing file ---");
  const result = await loadOrDefault(missingPath, { fallback: true });
  console.log("loadOrDefault on a missing file returned the default:", result);

  // Cleanup: remove the files this example created so the lesson folder stays clean.
  await unlink(textPath);
  await unlink(configPath);
  console.log("\nCleaned up temporary files.");
}

main().catch((err) => {
  console.error("Unexpected error:", err);
  process.exitCode = 1;
});
