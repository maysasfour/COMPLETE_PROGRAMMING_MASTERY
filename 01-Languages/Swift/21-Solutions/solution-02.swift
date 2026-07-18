// solution-02.swift -- Exercise 02: Struct vs. Class Aliasing

struct PointStruct {
    var x: Int
    var y: Int
}

class PointClass {
    var x: Int
    var y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

func movedRight(_ p: PointStruct) -> PointStruct {
    // `p` is a COPY of whatever was passed in (structs are value types), so mutating a
    // local copy here can never affect the caller's original argument.
    var moved = p
    moved.x += 1
    return moved
}

print("--- struct value semantics ---")
let original = PointStruct(x: 1, y: 1)
var second = original // COPIES original's fields -- `second` is an entirely independent value
second.x = 99
print("original: (\(original.x), \(original.y))") // untouched
print("second:   (\(second.x), \(second.y))")     // only this one changed

print("\n--- class reference semantics ---")
let classOriginal = PointClass(x: 1, y: 1)
let classSecond = classOriginal // COPIES the REFERENCE, not the object -- both point at one instance
classSecond.x = 99 // legal even though `classSecond` is `let`: the reference itself isn't reassigned,
                    // only a stored property of the object it points to
print("classOriginal: (\(classOriginal.x), \(classOriginal.y))") // ALSO shows 99 -- aliasing
print("classSecond:   (\(classSecond.x), \(classSecond.y))")

print("\n--- movedRight leaves its by-value argument untouched ---")
let arg = PointStruct(x: 5, y: 5)
let result = movedRight(arg)
print("arg (unchanged):    (\(arg.x), \(arg.y))")
print("result (arg.x + 1): (\(result.x), \(result.y))")
