// example.ts - typeof/in narrowing, discriminated unions, and an exhaustive switch.

console.log("--- typeof narrowing ---");
function formatValue(value: string | number): string {
  if (typeof value === "string") {
    return value.toUpperCase();
  }
  return value.toFixed(2);
}
console.log(formatValue("hello"));
console.log(formatValue(3.14159));

console.log("\n--- in narrowing on a discriminated union ---");
interface Circle {
  kind: "circle";
  radius: number;
}
interface Square {
  kind: "square";
  side: number;
}
type Shape = Circle | Square;

function areaByIn(shape: Shape): number {
  if ("radius" in shape) {
    return Math.PI * shape.radius ** 2;
  }
  return shape.side ** 2;
}

const circle: Shape = { kind: "circle", radius: 3 };
const square: Shape = { kind: "square", side: 4 };
console.log("circle area:", areaByIn(circle));
console.log("square area:", areaByIn(square));

console.log("\n--- exhaustive switch on the discriminant ---");
function areaBySwitch(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "square":
      return shape.side ** 2;
    default: {
      // If Shape ever gained a third variant without a matching case above,
      // `shape` here would no longer be `never` and this line would fail to compile.
      const _exhaustive: never = shape;
      return _exhaustive;
    }
  }
}
console.log("circle area (switch):", areaBySwitch(circle));
console.log("square area (switch):", areaBySwitch(square));

// If we added `interface Triangle { kind: "triangle"; base: number; height: number }`
// to `Shape` without adding a `case "triangle":` above, the `default` branch's
// `shape` would include the Triangle variant, which is NOT assignable to `never`,
// and the whole file would fail to compile until the switch was updated.
