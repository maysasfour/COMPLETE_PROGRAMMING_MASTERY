// example.ts - a "before" (any/unchecked) and "after" (properly typed/validated) contrast.

console.log("=== BEFORE: any everywhere, no validation ===");
function getDiscountedPriceBad(price: any, discountPercent: any): any {
  const discount = discountPercent || 10; // || silently overrides an intentional 0
  return price - (price * discount) / 100;
}
console.log("getDiscountedPriceBad(100, 20):", getDiscountedPriceBad(100, 20));
console.log(
  "getDiscountedPriceBad(100, 0):",
  getDiscountedPriceBad(100, 0),
  "<- BUG: intentional 0% discount silently replaced with 10%"
);
console.log(
  "getDiscountedPriceBad('oops', 20):",
  getDiscountedPriceBad("oops", 20),
  "<- BUG: `any` let a string through with zero compile-time warning"
);

console.log("\n=== AFTER: precise types, ?? instead of ||, validated boundary data ===");
function getDiscountedPrice(price: number, discountPercent: number): number {
  const discount = discountPercent ?? 10;
  return price - (price * discount) / 100;
}
console.log("getDiscountedPrice(100, 20):", getDiscountedPrice(100, 20));
console.log(
  "getDiscountedPrice(100, 0):",
  getDiscountedPrice(100, 0),
  "<- correct: intentional 0% discount honored"
);
// getDiscountedPrice("oops", 20); // would fail to COMPILE -- caught before ever running

console.log("\n=== validating external data instead of trusting an annotation ===");
interface PriceInput {
  price: number;
  discountPercent: number;
}

function isPriceInput(value: unknown): value is PriceInput {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as PriceInput).price === "number" &&
    typeof (value as PriceInput).discountPercent === "number"
  );
}

function processExternalInput(raw: unknown): number | null {
  if (!isPriceInput(raw)) {
    return null;
  }
  return getDiscountedPrice(raw.price, raw.discountPercent);
}

console.log("Valid external input:", processExternalInput({ price: 100, discountPercent: 15 }));
console.log("Malformed external input:", processExternalInput({ price: "oops" }));
