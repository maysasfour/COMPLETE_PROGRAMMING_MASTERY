# TypeScript Cheat Sheet

[Back to course overview](README.md)

## Basic Types

```ts
let n: number = 42;
let s: string = "hi";
let b: boolean = true;
let arr: number[] = [1, 2, 3];
let tuple: [string, number] = ["Ada", 30];
let map: Map<string, number> = new Map();
let anyValue: any = "opts out of checking entirely -- avoid";
let unknownValue: unknown = "safe -- must narrow before use";
```

## Object Shapes

```ts
interface User {
  id: number;
  name: string;
  email?: string;       // optional
  readonly createdAt: string; // compile-time-only immutability
}

type Point = { x: number; y: number }; // `type` works too for plain shapes
type Status = "pending" | "active" | "done"; // literal union -- `type` required, not `interface`
```

## Functions

```ts
function add(a: number, b: number): number { return a + b; }
function greet(name: string = "World"): string { return `Hello, ${name}`; }
function describe(name: string, nickname?: string): string { return nickname ?? name; }
function sum(...nums: number[]): number { return nums.reduce((a, b) => a + b, 0); }

// Overloads: precise return type per input type
function parseValue(v: string): string;
function parseValue(v: number): number;
function parseValue(v: string | number): string | number {
  return typeof v === "string" ? v.trim() : Math.round(v);
}
```

## Narrowing

```ts
function formatValue(v: string | number) {
  if (typeof v === "string") return v.toUpperCase(); // narrowed to string
  return v.toFixed(2); // narrowed to number
}

function isString(v: unknown): v is string { return typeof v === "string"; } // type guard
```

## Discriminated Unions + Exhaustiveness

```ts
interface Circle { kind: "circle"; radius: number }
interface Square { kind: "square"; side: number }
type Shape = Circle | Square;

function area(s: Shape): number {
  switch (s.kind) {
    case "circle": return Math.PI * s.radius ** 2;
    case "square": return s.side ** 2;
    default: { const _exhaustive: never = s; return _exhaustive; }
  }
}
```

## `Record`, `readonly`

```ts
type Role = "admin" | "editor" | "viewer";
const perms: Record<Role, string[]> = {
  admin: ["read", "write", "delete"],
  editor: ["read", "write"],
  viewer: ["read"],
}; // omitting any Role key is a compile error

const nums: readonly number[] = [1, 2, 3]; // .push() etc. disabled at compile time
```

## Assertions vs. Guards (prefer guards)

```ts
const x = someValue as string; // UNCHECKED -- "trust me"
const y = maybeNull!;           // UNCHECKED non-null assertion

if (isString(someValue)) { /* genuinely checked */ }
```

## Template Literal Types

```ts
type EventName = "click" | "hover";
type HandlerName = `on${Capitalize<EventName>}`; // "onClick" | "onHover"
type HexColor = `#${string}`; // any string starting with "#"
```

## Compiling

```bash
tsc file.ts --strict --target ES2022 --skipLibCheck
node file.js
```
