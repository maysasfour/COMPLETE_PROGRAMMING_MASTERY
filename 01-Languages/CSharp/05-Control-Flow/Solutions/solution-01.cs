// solution-01.cs - FizzBuzz as a switch expression with when guards.

string FizzBuzz(int n) => n switch {
    int x when x % 15 == 0 => "FizzBuzz",
    int x when x % 3 == 0 => "Fizz",
    int x when x % 5 == 0 => "Buzz",
    _ => n.ToString(),
};

for (int i = 1; i <= 15; i++) {
    Console.WriteLine(FizzBuzz(i));
}
