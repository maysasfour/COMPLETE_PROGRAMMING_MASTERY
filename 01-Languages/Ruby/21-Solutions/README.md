# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Worked, verified solutions to all seven [20-Exercises](../20-Exercises/README.md) problems. Each was actually run with `ruby`; the captured output below is real, not hand-computed.

## Solution 1 — Symbol-Keyed Config Validator

[solution-01.rb](solution-01.rb)

```
{host: "localhost", port: 8080, timeout: 30} -> VALID
{host: "localhost", port: 99999, timeout: nil} -> port must be an Integer between 1 and 65535
{port: 8080} -> host must be a non-empty String
```

## Solution 2 — Spaceship Operator for a `Version` Class

[solution-02.rb](solution-02.rb)

```
v1 < v2? true
v3 > v4? true
["1.0.0", "1.2.0", "1.10.0"]
(lexical string sort would wrongly put 1.10.0 before 1.2.0 -- this uses real numeric [major,minor,patch] comparison instead)
```

## Solution 3 — Vending Machine via `case`/`when`

[solution-03.rb](solution-03.rb)

```
Dispensed soda -- change: 50
Dispensed chips -- change: 0
Dispensed candy -- change: 400
Insufficient funds -- need 50 more
caught: unrecognized product code: :water
```

## Solution 4 — Retry-With-Backoff Using a Block

[solution-04.rb](solution-04.rb)

```
succeeded on attempt 3
total simulated failures before success: 2
```

## Solution 5 — Top-N Word Frequencies via `Enumerable` Chaining

[solution-05.rb](solution-05.rb)

```
the: 4
fox: 3
and: 1
```

## Solution 6 — Custom Exception Hierarchy with `retry`

[solution-06.rb](solution-06.rb)

```
attempt 1 failed with TimeoutError: attempt 1 timed out
attempt 2 failed with ConnectionRefusedError: attempt 2 was refused
succeeded on attempt 3: data!
```

## Solution 7 — Capstone: Shape Hierarchy with a Mixin and Duck Typing

[solution-07.rb](solution-07.rb)

```
Circle: area=28.27, perimeter=18.85
Rectangle: area=20, perimeter=18
Circle: area=3.14, perimeter=6.28
total area: 51.42
Object.new responds_to?(:describe) = false
Circle.new(1) responds_to?(:describe) = true
```

## Run Them All

```bash
cd 01-Languages/Ruby/21-Solutions
for f in solution-*.rb; do echo "=== $f ==="; ruby "$f"; done
```

## Recommended Next Lesson

[22 — Mini-Projects](../22-Mini-Projects/README.md)
