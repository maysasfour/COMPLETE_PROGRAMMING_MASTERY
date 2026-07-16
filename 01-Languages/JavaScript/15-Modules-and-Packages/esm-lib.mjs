// esm-lib.mjs - a small ES module, imported by esm-example.mjs via import/export.
// The .mjs extension forces Node to treat this file as an ES module regardless
// of any package.json "type" field.

export function greet(name) {
  return `Hello, ${name}!`;
}

export const VERSION = "1.0.0";

export default function farewell(name) {
  return `Goodbye, ${name}.`;
}
