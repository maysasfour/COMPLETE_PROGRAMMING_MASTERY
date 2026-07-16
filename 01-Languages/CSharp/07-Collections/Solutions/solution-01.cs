// solution-01.cs - word frequency counting with a Dictionary, ranked via LINQ.

using System.Linq;
using System.Text.RegularExpressions;

Dictionary<string, int> WordFrequency(string text) {
    var cleaned = Regex.Replace(text.ToLower(), "[.,!?]", "");
    var words = cleaned.Split(' ', StringSplitOptions.RemoveEmptyEntries);
    var counts = new Dictionary<string, int>();
    foreach (var word in words) {
        counts[word] = counts.GetValueOrDefault(word, 0) + 1;
    }
    return counts;
}

List<KeyValuePair<string, int>> TopN(Dictionary<string, int> freq, int n) {
    return freq
        .OrderByDescending(kv => kv.Value)
        .ThenBy(kv => kv.Key)
        .Take(n)
        .ToList();
}

var freq = WordFrequency("Cats, cats, and dogs. Dogs love cats!");
foreach (var kv in TopN(freq, 2)) {
    Console.WriteLine($"{kv.Key}: {kv.Value}");
}
