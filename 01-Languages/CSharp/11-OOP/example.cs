// example.cs - virtual/override polymorphism, interfaces + abstract classes, record value equality.

Console.WriteLine("--- virtual/override polymorphism ---");
Animal a = new Dog("Rex");
Console.WriteLine(a.Speak());

Console.WriteLine("\n--- interface + abstract class ---");
ShapeBase circle = new Circle(3);
Console.WriteLine(circle.Describe());
Console.WriteLine($"circle is IShape: {circle is IShape}");

Console.WriteLine("\n--- record value equality vs class reference equality ---");
var p1 = new Point(1, 2);
var p2 = new Point(1, 2);
Console.WriteLine($"p1 == p2 (records): {p1 == p2}");
Console.WriteLine($"p1.Equals(p2): {p1.Equals(p2)}");
Console.WriteLine($"p1.ToString() (auto-generated): {p1}");

var c1 = new PointClass { X = 1, Y = 2 };
var c2 = new PointClass { X = 1, Y = 2 };
Console.WriteLine($"c1 == c2 (classes, reference equality): {c1 == c2}");

class Animal {
    public string Name { get; }
    public Animal(string name) { Name = name; }
    public virtual string Speak() => $"{Name} makes a sound";
}

class Dog : Animal {
    public Dog(string name) : base(name) {}
    public override string Speak() => $"{Name} says Woof";
}

interface IShape {
    double Area();
}

abstract class ShapeBase : IShape {
    public abstract double Area();
    public string Describe() => $"Area: {Area():F2}";
}

class Circle : ShapeBase {
    private readonly double radius;
    public Circle(double radius) { this.radius = radius; }
    public override double Area() => Math.PI * radius * radius;
}

record Point(double X, double Y);

class PointClass { public double X, Y; }
