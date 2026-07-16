// solution-01.cs - TrySplitName using the out/TryParse convention.

bool TrySplitName(string fullName, out string first, out string last) {
    var parts = fullName.Split(' ');
    if (parts.Length != 2) {
        first = "";
        last = "";
        return false;
    }
    first = parts[0];
    last = parts[1];
    return true;
}

if (TrySplitName("Ada Lovelace", out var f, out var l)) {
    Console.WriteLine($"{f} / {l}");
}
if (!TrySplitName("Madonna", out var f2, out var l2)) {
    Console.WriteLine("Split failed as expected");
}
