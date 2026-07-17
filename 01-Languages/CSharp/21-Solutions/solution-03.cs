// solution-03.cs - LINQ Sales Report
// See: ../20-Exercises/README.md#exercise-03--linq-sales-report-intermediate
//
// Run with:
//     dotnet run solution-03.cs

var sales = new List<Sale> {
    new("Widget", "North", 100m),
    new("Widget", "South", 150m),
    new("Widget", "North", 75m),
    new("Gadget", "North", 300m),
    new("Gadget", "South", 50m),
    new("Gizmo",  "East",  20m),
    new("Gizmo",  "East",  5m),
    new("Widget", "East",  40m),
    new("Gadget", "East",  60m),
    new("Gizmo",  "North", 500m),
};

Console.WriteLine("--- total revenue per product (descending) ---");
var revenuePerProduct = sales
    .GroupBy(s => s.Product)
    .Select(g => (Product: g.Key, Total: g.Sum(s => s.Amount)))
    .OrderByDescending(x => x.Total);
foreach (var (product, total) in revenuePerProduct) {
    Console.WriteLine($"  {product}: {total:C}");
}

Console.WriteLine("\n--- highest-value single sale ---");
// MaxBy avoids the need to OrderByDescending().First() for a single winner.
var topSale = sales.MaxBy(s => s.Amount)!;
Console.WriteLine($"  {topSale.Product} in {topSale.Region}: {topSale.Amount:C}");

Console.WriteLine("\n--- regions selling more than one distinct product ---");
var multiProductRegions = sales
    .GroupBy(s => s.Region)
    .Where(g => g.Select(s => s.Product).Distinct().Count() > 1)
    .Select(g => g.Key);
foreach (var region in multiProductRegions) {
    Console.WriteLine($"  {region}");
}

Console.WriteLine("\n--- average sale amount ---");
Console.WriteLine($"  {sales.Average(s => s.Amount):F2}");

record Sale(string Product, string Region, decimal Amount);
