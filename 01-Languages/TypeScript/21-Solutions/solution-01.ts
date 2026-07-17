// solution-01.ts - generic pluck<T, K extends keyof T> (Exercise 01)

// `K extends keyof T` is what lets the return type be `T[K][]` instead of `unknown[]` --
// the compiler knows *which* property was requested and can look up its exact type.
function pluck<T, K extends keyof T>(items: T[], key: K): T[K][] {
  return items.map((item) => item[key]);
}

interface Person {
  id: number;
  name: string;
  age: number;
}

const people: Person[] = [
  { id: 1, name: "Ada", age: 36 },
  { id: 2, name: "Grace", age: 85 },
  { id: 3, name: "Alan", age: 41 },
];

const names = pluck(people, "name"); // inferred string[]
const ages = pluck(people, "age"); // inferred number[]

console.log("names:", names, "-- typeof first element:", typeof names[0]);
console.log("ages:", ages, "-- typeof first element:", typeof ages[0]);

// pluck(people, "nonexistentField"); // would NOT compile -- "nonexistentField" is not keyof Person
