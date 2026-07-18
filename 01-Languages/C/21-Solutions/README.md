# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Worked solutions to [20-Exercises](../20-Exercises/README.md). Every file below was genuinely compiled with `cl /std:c17 /nologo /W4` (zero warnings) and run; output is pasted verbatim, not fabricated.

## 1. [ex1_reverse.c](ex1_reverse.c)

```
Before: 1 2 3 4 5 6
After:  6 5 4 3 2 1
```

## 2. [ex2_vector.c](ex2_vector.c)

```
length=10 capacity=16
contents: 1 4 9 16 25 36 49 64 81 100
allocs=1 frees=1 (balanced=yes)
```

`allocs` stays at `1` (not incremented on every grow) because the counter only tracks the *first* allocation (`v->data == NULL`); subsequent grows are `realloc`s of the same block, still requiring exactly one final `free` — which the printed `balanced=yes` confirms.

## 3. [ex3_account.c](ex3_account.c)

```
Mays: balance = 100.00
Mays: balance = 150.00
withdraw 30.0 -> OK
Mays: balance = 120.00
withdraw 1000.0 -> FAILED (insufficient funds)
Mays: balance = 120.00
```

## 4. [ex4_callbacks.c](ex4_callbacks.c)

```
Values: 3 1 4 1 5 9 2 6
Sum via callback: 31
```

## 5. [ex5_linkedlist.c](ex5_linkedlist.c)

```
50 -> 40 -> 30 -> 20 -> 10 -> NULL
allocs=5 frees=5 (balanced=yes)
```

## 6. [ex6_main.c](ex6_main.c) + [shapes.h](shapes.h) / [shapes.c](shapes.c)

```bash
cl /std:c17 /nologo /W4 ex6_main.c shapes.c /Fe:ex6_main.exe
```

```
radius = 5.0
area = 78.5398
perimeter = 31.4159
```

## 7. [ex7_tokenizer.c](ex7_tokenizer.c)

```
Tokens:
  apples
  bread
  milk
  eggs
```

## Recommended Next

[22 — Mini-Projects](../22-Mini-Projects/README.md)
