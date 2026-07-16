// example.ts - a generically-typed withLogging wrapper, and a typed two-step pipe.

console.log("--- generically-typed higher-order function ---");
function withLogging<Args extends unknown[], Return>(
  fn: (...args: Args) => Return
): (...args: Args) => Return {
  return (...args: Args): Return => {
    console.log(`Calling ${fn.name} with`, args);
    const result = fn(...args);
    console.log(`${fn.name} returned`, result);
    return result;
  };
}

function add(a: number, b: number): number {
  return a + b;
}

const loggedAdd = withLogging(add);
const sum = loggedAdd(2, 3); // still typed as `number` -- signature fully preserved
console.log("Type-checked result:", sum.toFixed(2));

console.log("\n--- typed two-step pipe ---");
function pipe<A, B, C>(fn1: (a: A) => B, fn2: (b: B) => C): (a: A) => C {
  return (a: A) => fn2(fn1(a));
}

const double = (n: number): number => n * 2;
const toCurrency = (n: number): string => `$${n.toFixed(2)}`;

const doubleAndFormat = pipe(double, toCurrency);
console.log("doubleAndFormat(21.5):", doubleAndFormat(21.5));
