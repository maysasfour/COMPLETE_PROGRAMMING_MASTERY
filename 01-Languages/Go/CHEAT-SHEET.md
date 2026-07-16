# Go Cheat Sheet

[Back to course overview](README.md)

## Variables and Types

```go
var age int = 30
var name = "Ada"      // inferred
count := 42             // short declaration, function-scope only

var zero int      // 0 -- Go always zero-initializes, never garbage
var s string       // ""
var b bool          // false
var p *int          // nil

const Pi = 3.14159
```

## Operators (No Overloading, No Ternary)

```go
a == b; a < b; a && b; !a
x := &a   // address-of
*x = 10    // dereference
// no ptr + 1 -- no pointer arithmetic
```

## Control Flow

```go
if x > 0 { } else if x == 0 { } else { }

switch x {
case 1, 2:
    // no fall-through by default!
default:
}

for i := 0; i < 3; i++ { }   // classic
for x < 10 { }                 // "while"
for { break }                    // infinite

for i, v := range slice { }
for k, v := range m { }
```

## Functions (Multiple Return Values!)

```go
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("cannot divide by zero")
    }
    return a / b, nil
}
result, err := divide(10, 2)
if err != nil { /* handle */ }

func sum(nums ...int) int { /* variadic */ }
```

## Collections

```go
arr := [3]int{1, 2, 3}   // fixed size, in the type
slice := []int{1, 2, 3}    // dynamic
slice = append(slice, 4)    // MUST reassign

m := map[string]int{"a": 1}
v, ok := m["key"]              // comma-ok idiom -- safe lookup
```

## Strings

```go
strings.ToUpper(s); strings.Split(s, ","); strings.Join(parts, "-")
len(s)                // BYTE length, not character count
for i, r := range s { } // rune iteration, correct UTF-8 decoding
strconv.Atoi("42"); strconv.Itoa(42)
```

## Error Handling (No Exceptions!)

```go
value, err := riskyOp()
if err != nil {
    return err // or handle it
}

type MyError struct{ Msg string }
func (e *MyError) Error() string { return e.Msg }

// panic/recover -- ONLY for truly exceptional situations
defer func() {
    if r := recover(); r != nil { /* ... */ }
}()
```

## OOP (No Classes!)

```go
type Animal struct { Name string }
func (a Animal) Speak() string { return a.Name + "..." } // method, explicit receiver

type Speaker interface { Speak() string } // implicit satisfaction, no "implements"

type Dog struct {
    Animal   // embedding -- composition, not inheritance
    Breed string
}
```

## Generics (Go 1.18+)

```go
func First[T any](items []T) T { return items[0] }
type Stack[T any] struct { items []T }
```

## Concurrency (Goroutines and Channels)

```go
go someFunc()                  // launch a goroutine
ch := make(chan int)
ch <- 5                          // send
v := <-ch                        // receive (blocks)

var wg sync.WaitGroup
wg.Add(1)
go func() { defer wg.Done(); /* ... */ }()
wg.Wait()

select {
case v := <-ch1:
case v := <-ch2:
}
```

## Running Code

```bash
go run main.go     # compile + run, no artifact left behind
go build            # produce a static binary
go test -v           # run tests (files named *_test.go)
go mod init module/path
```
