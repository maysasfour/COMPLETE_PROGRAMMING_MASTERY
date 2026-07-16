// example.ts - the JSON.parse gap, and a validated generic readJsonFile<T> helper.

const { readFile, writeFile, unlink } = require("node:fs/promises");
const path = require("node:path");

interface Config {
  theme: string;
  fontSize: number;
}

function isConfig(value: unknown): value is Config {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as Config).theme === "string" &&
    typeof (value as Config).fontSize === "number"
  );
}

async function readJsonFile<T>(
  filePath: string,
  validate: (value: unknown) => value is T
): Promise<T> {
  const raw: string = await readFile(filePath, "utf8");
  const parsed: unknown = JSON.parse(raw);
  if (!validate(parsed)) {
    throw new Error(`File at ${filePath} does not match the expected shape`);
  }
  return parsed;
}

async function main() {
  const validConfigPath = path.join(__dirname, "config.json");
  const invalidConfigPath = path.join(__dirname, "bad-config.json");

  console.log("--- writing and reading a valid config ---");
  await writeFile(validConfigPath, JSON.stringify({ theme: "dark", fontSize: 14 }), "utf8");
  const config = await readJsonFile<Config>(validConfigPath, isConfig);
  console.log("Validated config:", config);

  console.log("\n--- attempting to read a malformed config ---");
  await writeFile(invalidConfigPath, JSON.stringify({ theme: "dark", fontSize: "not-a-number" }), "utf8");
  try {
    await readJsonFile<Config>(invalidConfigPath, isConfig);
  } catch (err) {
    if (err instanceof Error) {
      console.log("Correctly rejected:", err.message);
    }
  }

  await unlink(validConfigPath);
  await unlink(invalidConfigPath);
  console.log("\nCleaned up temporary files.");
}

main().catch((err) => {
  console.error("Unexpected error:", err);
  process.exitCode = 1;
});
