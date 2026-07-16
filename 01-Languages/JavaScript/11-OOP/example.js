// example.js - classes, private fields, getters, inheritance, super, instanceof, static members.

class Animal {
  static #totalCreated = 0;
  #energy = 100;

  constructor(name, sound) {
    this.name = name;
    this.sound = sound;
    Animal.#totalCreated += 1;
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

  static getTotalCreated() {
    return Animal.#totalCreated;
  }
}

class Dog extends Animal {
  constructor(name) {
    super(name, "Woof");
    this.breed = "Unknown";
  }

  fetch() {
    return `${this.name} fetches the ball!`;
  }
}

class Cat extends Animal {
  constructor(name) {
    super(name, "Meow");
  }

  // Overrides the base implementation -- polymorphism in action.
  makeSound() {
    return `${super.makeSound()} (aloofly)`;
  }
}

console.log("--- basic instances and inheritance ---");
const rex = new Dog("Rex");
const whiskers = new Cat("Whiskers");
console.log(rex.makeSound());
console.log(rex.fetch());
console.log(whiskers.makeSound()); // uses the overridden version, which still calls super.makeSound()

console.log("\n--- instanceof across the hierarchy ---");
console.log("rex instanceof Dog:", rex instanceof Dog);
console.log("rex instanceof Animal:", rex instanceof Animal);
console.log("rex instanceof Cat:", rex instanceof Cat);

console.log("\n--- private field access ---");
console.log("whiskers.energyLevel (via getter):", whiskers.energyLevel);
console.log("whiskers.#energy directly:", whiskers["#energy"], "(undefined -- # is not a normal property name)");

console.log("\n--- static counter shared across the whole hierarchy ---");
new Dog("Fido");
new Cat("Tom");
console.log("Animal.getTotalCreated():", Animal.getTotalCreated());
