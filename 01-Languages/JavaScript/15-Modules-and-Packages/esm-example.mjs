// esm-example.mjs - demonstrates ES module import/export (named + default).

import farewell, { greet, VERSION } from "./esm-lib.mjs";

console.log(greet("Ada"));
console.log("Library version:", VERSION);
console.log(farewell("Ada"));
