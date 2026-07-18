# 14 — Concurrency

[Back to course overview](../README.md) | [Previous: No Generics](../13-No-Generics/README.md)

## Learning Objectives

- Understand why Perl's `threads` module is generally discouraged for application code (heavyweight interpreter-clone model, not lightweight green threads).
- Verify live whether `threads` and `fork()` actually work in this msys2/Git-for-Windows Perl build.

## Concept

### `threads` — verified live, but discouraged

Perl's `threads` module gives each "thread" a full clone of the interpreter (unlike OS-native lightweight threads or Python's GIL-shared threads) — this makes it heavyweight and memory-hungry, and it's widely considered a last resort in the Perl community (prefer `fork`, `Parallel::ForkManager`, or async/event-loop modules like `AnyEvent`/`IO::Async` for real concurrency work). It was, however, confirmed present and working in this environment:

```bash
$ perl -Mthreads -e "print 1"
```
Output (actual): `1`

Full working demo, [`threads_demo.pl`](threads_demo.pl), run with `perl threads_demo.pl`. Output (actual):

```
Locale 'C.UTF-8' is unsupported, and may crash the interpreter.
worker 1 done
worker 2 done
worker 3 done
worker 4 done
final counter (expect 4000): 4000
```

Two honest observations from the real run:
1. **Gotcha**: a genuine warning (`Locale 'C.UTF-8' is unsupported, and may crash the interpreter.`) was emitted by this specific msys2 build when `threads` initializes — the script still completed correctly and the shared counter reached the expected `4000`, but the warning is real, undocumented-away, and worth knowing about if deploying threaded Perl on this platform.
2. `threads::shared` + `lock($counter)` correctly serialized 4 workers each incrementing 1000 times to a final total of exactly 4000 — confirming real mutex-protected shared state, not merely 4 independent counters.

### `fork()` — verified live, works on this build

Despite `fork()` being a genuinely awkward, partially-emulated feature on native Windows Perl builds historically, this **msys2** Perl (bundled with Git for Windows, which is a Unix-like POSIX layer) implements real Unix `fork()` semantics, confirmed by running [`fork_demo.pl`](fork_demo.pl) with `perl fork_demo.pl`. Output (actual):

```
child pid 6788: hello from the child
parent pid 6787: spawned child 6788
parent: reaped pid 6788, child exit status 0
```

The parent and child genuinely received different PIDs (`6787` vs `6788`), and `waitpid` correctly reaped the child and reported its exit status — this is real POSIX `fork()`, not Perl's Windows-only pseudo-fork emulation (which spawns a new interpreter thread rather than a real process and has well-known limitations with filehandles/sockets). This works here specifically because msys2 provides a genuine POSIX layer under Git for Windows; a plain ActiveState/Strawberry Perl on native Windows would instead use `fork()` emulation with different (more limited) behavior — that distinction was not tested here since only the msys2 build was available.

## Common beginner mistakes

- Reaching for `threads` by default for "I need concurrency" — for CPU-bound parallelism, `fork`-based worker pools are usually preferred in Perl; for I/O-bound concurrency, event-loop modules are preferred.
- Forgetting `lock()` around shared-variable mutation with `threads::shared` — without it, increments race and the final count will not equal the expected total.
- Not reaping child processes with `waitpid`/`wait` after `fork()`, leaving zombie processes.

## Best practices

- Prefer `fork()` + `waitpid` (or `Parallel::ForkManager` from CPAN) over `threads` for CPU-bound parallel work in Perl.
- Always mark shared state explicitly with `:shared` and guard mutations with `lock()` when using `threads::shared`.
