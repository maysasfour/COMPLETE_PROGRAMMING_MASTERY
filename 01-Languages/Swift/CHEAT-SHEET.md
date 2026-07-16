# Swift Cheat Sheet

[Back to course overview](README.md)

> **Not verified by execution** — see the [course README](README.md) for the disclosed reason. Use with appropriate caution and verify against a real Swift toolchain if possible.

## Variables and Optionals

```swift
let age: Int = 30          // let = constant, the idiomatic default
var count = 0                 // var = reassignable

let name: String = "Ada"       // can NEVER be nil
let nickname: String? = nil     // explicitly optional

nickname?.count                 // safe call -- nil if nickname is nil
nickname ?? "default"             // nil-coalescing operator
nickname!.count                    // force unwrap -- CRASHES if actually nil

guard let value = nickname else { return } // early-exit unwrap, value usable afterward
if let value = nickname { }               // scoped unwrap, value usable only in this block
```

## Operators

```swift
Double(5) + 2.5     // explicit conversion required -- no implicit Int->Double
1...5                  // closed range, includes 5
1..<5                   // half-open range, excludes 5
stride(from: 1, through: 10, by: 3)

struct Point: Equatable { let x: Int; let y: Int }  // == synthesized automatically

struct Vec { let x: Double
    static func + (l: Vec, r: Vec) -> Vec { Vec(x: l.x + r.x) } // operator overload
}
```

## Control Flow

```swift
let grade = score >= 90 ? "A" : "B"  // ternary (Swift HAS one, unlike some languages)

switch x {
case 1, 2: print("one or two")   // no break needed -- NO fall-through by default
case 3...10: print("three to ten")
default: print("other")             // required unless exhaustive (enum)
}

switch x {
case _ where x % 2 == 0: print("even") // where clause
default: break
}

for i in 0..<3 { }
while i < 3 { i += 1 }
```

## Functions

```swift
func greet(person name: String, greeting: String = "Hi") -> String {
    return "\(greeting), \(name)!"           // "person" = external label, "name" = internal
}
greet(person: "Ada")

func multiply(_ a: Int, by b: Int) -> Int { a * b }  // _ omits the label
multiply(3, by: 4)

func increment(_ n: inout Int) { n += 1 }
var x = 5
increment(&x)                          // & REQUIRED at call site

let double: (Int) -> Int = { $0 * 2 }   // $0 = implicit first param, like Kotlin's `it`
nums.map { $0 * 2 }                       // trailing closure syntax
```

## Collections (VALUE types -- no aliasing!)

```swift
var a = [1, 2, 3]
var b = a          // COPIES a -- NOT aliased (unlike Kotlin's MutableList)
b.append(4)          // a is UNCHANGED

let dict: [String: Any] = ["name": "Ada"]
dict["missing"]         // nil, no exception

var set: Set<Int> = [1, 2, 2, 3]  // {1, 2, 3} -- duplicates removed

nums.map { $0 * 2 }; nums.filter { $0 > 0 }; nums.reduce(0, +)
arr.sorted()   // NEW array
arr.sort()       // mutates IN PLACE
```

## Strings (Unicode-correct .count -- O(n), not O(1)!)

```swift
"Hello, \(name)! Next year: \(age + 1)"  // string interpolation

let raw = """
    multi-line, no escaping needed
    """

"🇺🇸".count            // 1 -- correctly ONE character, even though it's 2 Unicode scalars
s.uppercased(); s.count; s.replacingOccurrences(of: "a", with: "b")
// s[0] -- COMPILE ERROR: use String.Index instead
```

## Error Handling

```swift
enum MyError: Error { case tooShort(min: Int) }

func validate(_ s: String) throws -> String {
    if s.count < 3 { throw MyError.tooShort(min: 3) }
    return s
}

do {
    let r = try validate("ok")
} catch MyError.tooShort(let min) {
    print("too short, need \(min)")
} catch {
    print("other: \(error)")
}

try? validate("hi")     // Optional -- nil on failure
try! validate("ok")       // force-try -- CRASHES if it actually throws
```

## OOP (struct = value type DEFAULT; class = reference type)

```swift
struct PointStruct { var x: Int; var y: Int }   // COPIED on assignment
class PointClass { var x: Int; init(x: Int) { self.x = x } }  // SHARED on assignment

protocol Speaker { func speak() -> String }
extension Speaker {                        // protocol extension = default implementation
    func announce() -> String { "Says: \(speak())" }
}

class Animal { func makeSound() -> String { "..." } }
class Cat: Animal { override func makeSound() -> String { "Meow!" } }  // override mandatory

enum Result {                                 // enum with associated values
    case success(data: String)
    case failure(code: Int)
}
```

## Generics

```swift
func maxOf<T: Comparable>(_ a: T, _ b: T) -> T { a > b ? a : b }

struct Stack<Element> {
    private var items: [Element] = []
    mutating func push(_ item: Element) { items.append(item) }  // mutating REQUIRED on struct
}

protocol Container {
    associatedtype Item          // placeholder, inferred per conforming type
    mutating func add(_ item: Item)
}
```

## Async/Concurrency (NATIVE -- no library needed, unlike Kotlin!)

```swift
func fetch() async -> Int { try? await Task.sleep(nanoseconds: 100_000_000); return 42 }

async let a = fetch()     // starts immediately
async let b = fetch()      // runs alongside a
let (ra, rb) = await (a, b) // suspends until BOTH finish

actor BankAccount {           // compiler-enforced, data-race-free mutable state
    var balance = 0.0
    func deposit(_ n: Double) { balance += n }
}
await account.deposit(100)  // await REQUIRED for every external access
```

## Modules (5 access levels: public != open!)

```swift
private class ...      // this scope only
fileprivate class ...  // this FILE only
internal class ...      // this MODULE only (the default)
public class ...          // other modules can USE, but not subclass
open class ...              // other modules can USE and SUBCLASS
```

```swift
// Package.swift (Swift Package Manager)
let package = Package(name: "MyProject", targets: [.executableTarget(name: "MyProject")])
```

## Database (no built-in access, like C++)

```swift
import SQLite3
var db: OpaquePointer?
sqlite3_open(":memory:", &db)
var stmt: OpaquePointer?
sqlite3_prepare_v2(db, "SELECT * FROM t WHERE id = ?", -1, &stmt, nil)
sqlite3_bind_int(stmt, 1, id)
```

## HTTP / JSON (Codable is BUILT IN!)

```swift
struct Todo: Codable { let id: Int; let title: String }

let (data, response) = try await URLSession.shared.data(from: url)
(response as? HTTPURLResponse)?.statusCode  // NO exception on 404 -- check this!

let todo = try JSONDecoder().decode(Todo.self, from: data)
let json = try JSONEncoder().encode(todo)
```

## Testing (XCTest -- built into the toolchain)

```swift
import XCTest
@testable import MyModule

final class MyTests: XCTestCase {
    override func setUp() { /* runs before EVERY test */ }

    func testItWorks() {
        XCTAssertEqual(2 + 2, 4)
    }

    func testThrows() {
        XCTAssertThrowsError(try riskyCall())
    }
}
```

## Running Code

```bash
swiftc file.swift -o binary && ./binary   # compile + run
swift file.swift                            # interpret directly, quick scripting
swift build; swift run; swift test           # Swift Package Manager commands
```
