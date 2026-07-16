// solution-01.js - polymorphic Shape hierarchy with a private field and reduce-based total.

class Shape {
  #name;

  constructor(name) {
    this.#name = name;
  }

  get name() {
    return this.#name;
  }

  area() {
    throw new Error("area() must be overridden by a subclass");
  }
}

class Rectangle extends Shape {
  constructor(width, height) {
    super("Rectangle");
    this.width = width;
    this.height = height;
  }

  area() {
    return this.width * this.height;
  }
}

class Circle extends Shape {
  constructor(radius) {
    super("Circle");
    this.radius = radius;
  }

  area() {
    return Math.PI * this.radius ** 2;
  }
}

function totalArea(shapes) {
  return shapes.reduce((sum, shape) => sum + shape.area(), 0);
}

const rect = new Rectangle(4, 5);
const circle = new Circle(3);

console.log(`${rect.name} area:`, rect.area());
console.log(`${circle.name} area:`, circle.area());
console.log("totalArea([rect, circle]):", totalArea([rect, circle]));

try {
  new Shape("Generic").area();
} catch (err) {
  console.log("Base Shape.area() correctly throws:", err.message);
}
