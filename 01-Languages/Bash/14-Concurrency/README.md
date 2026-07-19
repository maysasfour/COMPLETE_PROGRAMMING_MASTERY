# 14 — Concurrency

[Back to Bash course](../README.md)

## Real Parallelism, Verified with Live Timing

Lesson 11 introduced `&`/`wait` for process management in general; here we use the same tools specifically to get genuine wall-clock speedup, and prove it with `time`.

### Sequential Baseline

```bash
$ time (
>   for i in 1 2 3; do sleep 0.3; done
> )

real	0m1.093s
user	0m0.015s
sys	0m0.077s
```

Three `sleep 0.3` calls run one after another take roughly 3 × 0.3s ≈ 0.9–1.1s, confirmed above.

### Parallel with `&` / `wait`

```bash
$ time (
>   for i in 1 2 3; do sleep 0.3 & done
>   wait
> )

real	0m0.508s
user	0m0.031s
sys	0m0.061s
```

Backgrounding all three `sleep 0.3` calls and waiting for all of them takes roughly 0.5s — close to the time of a **single** `sleep 0.3`, not the sum of three, because they genuinely ran concurrently as separate OS processes.

### `xargs -P` for Parallel Execution

```bash
$ time (seq 1 4 | xargs -P4 -I{} bash -c 'sleep 0.3; echo done {}')
done 1
done 2
done 3
done 4

real	0m0.691s
user	0m0.090s
sys	0m0.337s
```

`xargs -P4` runs up to 4 invocations of the given command concurrently (`-I{}` substitutes each input line for `{}`). Four 0.3s tasks completed in ~0.69s rather than ~1.2s sequential — real parallelism, with the extra overhead here coming from `xargs` spawning a fresh `bash -c` process per item.

## When to Use Which

| Tool | Best for |
|---|---|
| `cmd &` / `wait` | A small, fixed number of background tasks you control directly in a script |
| `xargs -P N` | Applying the same command to a stream of many inputs with a bounded worker count |
| GNU `parallel` (external tool, not always installed) | Complex parallel pipelines with per-job output management |

## Common Beginner Mistakes

- Backgrounding many jobs without any concurrency limit, exhausting system resources (`xargs -P` bounds this; a raw loop with `&` does not).
- Forgetting `wait`, so the script exits before background jobs finish.
- Assuming background jobs share variables with the parent shell — each backgrounded command is its own process (or subshell for compound commands), so writes to variables inside it do not propagate back out.

## Best Practices

- Use `xargs -P` (with an explicit `-P N`) when parallelizing over a list of inputs, to bound concurrency.
- Always `wait` for jobs you background directly with `&`, capturing PIDs if you need to check individual exit statuses.
- Measure with `time` before assuming parallelization helped — for very fast tasks, process-spawning overhead can outweigh the benefit.

## Interview Questions

1. How would you prove that two background jobs are genuinely running concurrently rather than one after another?
2. What does `xargs -P4` do differently from a plain loop with `&`?
3. Why might backgrounding hundreds of jobs at once be a bad idea even on a multi-core machine?
