// solution-01.cs - Records vs. Classes
// See: ../20-Exercises/README.md#exercise-01--records-vs-classes-beginner
//
// Run with:
//     dotnet run solution-01.cs

Console.WriteLine("--- record value equality ---");
var p1 = new Point3D(1, 2, 3);
var p2 = new Point3D(1, 2, 3);
Console.WriteLine($"p1 == p2 : {p1 == p2}");
Console.WriteLine($"p1.ToString() (auto-generated): {p1}");

Console.WriteLine("\n--- class reference equality ---");
var m1 = new MutablePoint3D(1, 2, 3);
var m2 = new MutablePoint3D(1, 2, 3);
// Same field values, but == falls back to reference equality because
// class does not override it the way record does automatically.
Console.WriteLine($"m1 == m2 : {m1 == m2}");
m1.Translate(1, 1, 1);
Console.WriteLine($"m1 after Translate(1,1,1): ({m1.X}, {m1.Y}, {m1.Z})");

Console.WriteLine("\n--- 'with' expression (non-destructive mutation) ---");
var p3 = p1 with { Z = 99 };
Console.WriteLine($"p3 (Z changed): {p3}");
Console.WriteLine($"p1 (unchanged, proving 'with' does not mutate the source): {p1}");

record Point3D(double X, double Y, double Z);

class MutablePoint3D {
    public double X { get; private set; }
    public double Y { get; private set; }
    public double Z { get; private set; }

    public MutablePoint3D(double x, double y, double z) {
        X = x; Y = y; Z = z;
    }

    public void Translate(double dx, double dy, double dz) {
        X += dx; Y += dy; Z += dz;
    }
}
