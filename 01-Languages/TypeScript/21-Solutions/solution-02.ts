// solution-02.ts - discriminated Shape union with exhaustiveness checking (Exercise 02)

interface Circle {
  kind: "circle";
  radius: number;
}
interface Rectangle {
  kind: "rectangle";
  width: number;
  height: number;
}
interface Triangle {
  kind: "triangle";
  base: number;
  height: number;
}
type Shape = Circle | Rectangle | Triangle;

function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rectangle":
      return shape.width * shape.height;
    case "triangle":
      return 0.5 * shape.base * shape.height;
    default: {
      // If a fourth Shape variant is ever added without a matching `case` above,
      // `shape` here stops being assignable to `never` and this line fails to compile --
      // that's the whole point of an exhaustiveness check: the bug is caught at build time.
      const exhaustive: never = shape;
      return exhaustive;
    }
  }
}

function describe(shape: Shape): string {
  return `${shape.kind}: area = ${area(shape).toFixed(2)}`;
}

const shapes: Shape[] = [
  { kind: "circle", radius: 5 },
  { kind: "rectangle", width: 4, height: 6 },
  { kind: "triangle", base: 3, height: 8 },
];

for (const shape of shapes) {
  console.log(describe(shape));
}
