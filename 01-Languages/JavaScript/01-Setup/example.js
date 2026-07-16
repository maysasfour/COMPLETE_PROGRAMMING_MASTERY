// example.js - confirms the Node runtime is installed and shows a few of its globals.

console.log("Hello, World");
console.log("Node.js version:", process.version);
console.log("Platform:", process.platform);
console.log("Current working directory:", process.cwd());

// `window` and `document` do not exist here -- they are browser-only globals.
console.log("typeof window:", typeof window); // "undefined" in Node
