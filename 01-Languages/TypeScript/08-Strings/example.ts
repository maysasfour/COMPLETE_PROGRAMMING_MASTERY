// example.ts - typed string methods, template literal types, and string pattern types.

console.log("--- typed string methods (unchanged from JS at runtime) ---");
function shout(text: string): string {
  return text.toUpperCase();
}
console.log(shout("hello"));

const userName: string = "Ada";
const greeting: string = `Hello, ${userName}`;
console.log(greeting);

console.log("\n--- template literal types deriving a union of handler names ---");
type EventName = "click" | "hover" | "focus";
type HandlerName = `on${Capitalize<EventName>}`; // "onClick" | "onHover" | "onFocus"

function registerHandler(name: HandlerName) {
  console.log(`Registered handler: ${name}`);
}

registerHandler("onClick");
registerHandler("onHover");
registerHandler("onFocus");
// registerHandler("onScroll"); // would fail to COMPILE -- not in the derived union

console.log("\n--- template literal type modeling a string pattern ---");
type HexColor = `#${string}`;

function setColor(color: HexColor) {
  console.log("Setting color to", color);
}

setColor("#ff0000");
setColor("#00ff00");
// setColor("red"); // would fail to COMPILE -- doesn't match the `#${string}` pattern
