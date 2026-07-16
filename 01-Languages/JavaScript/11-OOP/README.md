# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define classes with fields, methods, and constructors.
- Use `extends`/`super` for inheritance.
- Use getters/setters and private fields for encapsulation.
- Explain that JavaScript classes are "syntactic sugar" over prototypal inheritance, not a separate object model.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

JavaScript's object model is fundamentally **prototypal**, not class-based — every object has an internal link to a "prototype" object it delegates property lookups to. ES6 `class` syntax was added as a cleaner, more familiar way to *write* that same prototypal system; it does not add a new kind of object model like Java or C#'s classes represent. Understanding this matters because it explains why `typeof MyClass` is `"function"` and why every instance of a class shares its methods via the prototype chain rather than each instance carrying its own copy.

## Syntax

```js
class Animal {
  #energy = 100; // private field (# prefix) -- not accessible as instance.energy from outside

  constructor(name, sound) {
    this.name = name;
    this.sound = sound;
  }

  makeSound() {
    return `${this.name} says ${this.sound}`;
  }

  get energyLevel() {
    return this.#energy;
  }

  rest() {
    this.#energy = Math.min(100, this.#energy + 10);
  }
}

const cat = new Animal("Whiskers", "Meow");
console.log(cat.makeSound());     // "Whiskers says Meow"
console.log(cat.energyLevel);      // 100 -- read through the getter, not a direct field
// console.log(cat.#energy);       // SyntaxError outside the class body -- truly private
```

Private fields (`#name`) were added in ES2022 and are enforced by the language itself, not just a naming convention — unlike a leading underscore (`_energy`), which is only a *convention* other code can still access.

## Inheritance with `extends`/`super`

```js
class Dog extends Animal {
  constructor(name) {
    super(name, "Woof"); // must call super() before using `this` in a derived class
    this.breed = "Unknown";
  }

  fetch() {
    return `${this.name} fetches the ball!`;
  }
}

const rex = new Dog("Rex");
console.log(rex.makeSound()); // inherited from Animal: "Rex says Woof"
console.log(rex.fetch());     // "Rex fetches the ball!"
console.log(rex instanceof Animal); // true
```

A derived class's constructor **must** call `super(...)` before it can reference `this` — the JavaScript engine enforces this at runtime with a `ReferenceError` if you try to use `this` first, unlike languages where the base constructor call is implicit.

## Static Members

```js
class Counter {
  static #count = 0; // shared across ALL instances, not per-instance

  constructor() {
    Counter.#count += 1;
  }

  static getCount() {
    return Counter.#count;
  }
}

new Counter(); new Counter(); new Counter();
console.log(Counter.getCount()); // 3
```

## Detailed Example

See [example.js](example.js) — an `Animal`/`Dog`/`Cat` hierarchy with a private field, a getter, inheritance, `super`, `instanceof`, and a static counter tracking how many animals have been created in total.

## Expected Output

Running `node example.js` prints each animal's sound (base and overridden versions), confirms `instanceof` recognizes both the specific subclass and the shared base class, demonstrates that a private field genuinely cannot be read as a plain property from outside the class, and shows a static counter correctly tracking the total instance count across all subclasses.

## Common Mistakes

- Forgetting `super(...)` in a derived class constructor before accessing `this` — throws a `ReferenceError`.
- Using a leading underscore (`_field`) and believing it's actually private — it's only a convention; true privacy requires `#field`.
- Assuming each instance carries its own copy of a method — methods defined in a class body live on the shared prototype, not per-instance, which is more memory-efficient but means mutating a method on one instance's prototype affects all instances.
- Confusing `static` members (belong to the class itself) with instance fields (belong to each object) — a `static` field is shared, not copied per instance.

## Best Practices

- Use `#privateField` for genuinely internal state; use a public getter if read access should be allowed without write access.
- Keep class hierarchies shallow — prefer composition (an object holding another object as a field) over deep inheritance chains where it fits, matching [09-Object-Oriented-Programming](../../../09-Object-Oriented-Programming/)'s general "composition over inheritance" guidance.
- Always call `super(...)` as the very first statement in a derived constructor, passing along whatever the base class constructor needs.
- Use `instanceof` sparingly for actual type-checking logic; prefer polymorphism (each subclass implementing its own version of a method) over `if (x instanceof Y)` branches scattered through calling code.

## Real-World Usage

Class hierarchies model domain entities in backend code (`User extends Person`, custom `Error` subclasses from Lesson 09) and UI component base classes in some frameworks; React's older class-component API (superseded by hooks) was itself built on exactly this `extends`/`super` pattern.

## Performance Considerations

Because methods live on the shared prototype rather than being recreated per instance, creating many class instances is cheaper than, say, defining closures-as-methods per object — a relevant distinction covered further alongside closures in Lesson 06/12.

## Summary

- JavaScript's object model is prototypal; `class` is syntax over that same system, not a separate mechanism.
- `#field` is enforced-private (ES2022); a leading underscore is only a naming convention.
- Derived classes must call `super(...)` before using `this`.
- `static` members belong to the class itself, shared across all instances, not copied per instance.

## Key Terms

- **Prototype** — the object every JavaScript object delegates property/method lookups to when a property isn't found on itself directly.
- **Private field (`#field`)** — an ES2022 class field enforced as inaccessible from outside the class body.
- **`super`** — calls the parent class's constructor (or accesses parent methods) from within a derived class.
- **Static member** — a field or method that belongs to the class itself, not to individual instances.

## Review Questions

1. Why is `#energy` more genuinely private than `_energy`?
2. What error occurs if a derived class constructor uses `this` before calling `super()`?
3. Why do all instances of a class share the same method implementations rather than each having their own copy?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **Is JavaScript's `class` syntax "real" classes, or something else under the hood?**
   Under the hood, it's still JavaScript's original prototypal inheritance model — `class` is syntactic sugar that makes writing prototype-based code look more like classical OOP from Java/C#. `typeof SomeClass` is `"function"`, confirming a class is still fundamentally a specially-marked function with a prototype object attached.

2. **What's the difference between a private field (`#field`) and a conventionally "private" field (`_field`)?**
   `#field` (ES2022) is enforced by the JavaScript engine itself — code outside the class body cannot read or write it, and attempting to do so is a `SyntaxError`/returns `undefined` depending on how it's accessed. `_field` is purely a naming convention signaling "please don't touch this from outside," but nothing stops external code from reading or writing it directly.

3. **What happens if you forget to call `super()` in a derived class's constructor?**
   Attempting to use `this` (implicitly or explicitly) before calling `super(...)` throws a `ReferenceError` — JavaScript requires the base class's constructor to run first to properly initialize the object before the derived class can add to it.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
