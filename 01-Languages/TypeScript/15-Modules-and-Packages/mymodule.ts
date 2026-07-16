// mymodule.ts - a small module using TypeScript's export syntax (compiles to ES module output).

export function add(a: number, b: number): number {
  return a + b;
}

export interface MathConstants {
  pi: number;
  e: number;
}

export const constants: MathConstants = {
  pi: 3.14159,
  e: 2.71828,
};

// A type-only export -- exists purely for the type checker, erased entirely on compilation.
export type Operation = "add" | "subtract" | "multiply" | "divide";
