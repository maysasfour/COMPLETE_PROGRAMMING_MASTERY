// Example.swift - Swift's String is a genuinely distinctive, Unicode-correct-by-default
// collection of Characters (extended grapheme clusters), NOT a simple byte or UTF-16 array
// -- meaning .count is O(n), not O(1), a real, deliberate performance/correctness trade-off
// unique among this repository's languages. Also: multi-line strings, string interpolation.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

let s = "Hello, World!"
print(s.uppercased())
print(s.lowercased())
print(s.count)                          // character count (grapheme clusters), not byte count
print(s.replacingOccurrences(of: "World", with: "Swift"))

// --- Multi-line strings ---
let raw = """
    Line one
    Line two with a literal backslash: \\n (escaped, so it prints as \\n, not a real newline)
    Line three with "quotes" needing no escaping at all
    """
print(raw)

// --- Swift's String.count is Unicode-correct: an emoji (multiple Unicode scalars combined
// into ONE grapheme cluster) counts as ONE Character, unlike a byte-counting approach ---
let flag = "🇺🇸" // the US flag emoji is actually TWO Unicode scalars (regional indicators) combined
print("flag.count: \(flag.count)") // 1 -- Swift correctly treats it as a single Character

let familyEmoji = "👨‍👩‍👧‍👦" // an emoji built from MULTIPLE combined Unicode scalars via zero-width joiners
print("familyEmoji.count: \(familyEmoji.count)") // 1 -- still a single Character/grapheme cluster
print("but familyEmoji.unicodeScalars.count: \(familyEmoji.unicodeScalars.count)") // 7 -- many scalars

// --- String is NOT directly indexable by integer -- must use String.Index ---
// print(s[0]) // COMPILE ERROR: 'subscript(_:)' is unavailable: cannot subscript String with an Int
let firstChar = s[s.startIndex] // String.Index, not a plain integer offset
print("first character: \(firstChar)")

// --- Substring via range ---
if let range = s.range(of: "World") {
    print("substring: \(s[range])")
}
