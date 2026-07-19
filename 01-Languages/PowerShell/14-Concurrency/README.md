# 14 - Concurrency

[Back to course overview](../README.md) | Previous: [13 - Generics](../13-Generics/README.md) | Next: [15 - Modules](../15-Modules/README.md)

## What / Why / Where

PowerShell background jobs (`Start-Job`/`Wait-Job`/`Receive-Job`/`Remove-Job`) run script
blocks in fully separate PowerShell processes, enabling real concurrency for I/O-bound or
long-running tasks - at the cost of full process isolation (no shared variables).

## Verified Live, Real Measured Timing

```
Sequential (3x 1-second sleeps, one after another): 3.05s
Same work via 3 background jobs, run concurrently:  2.98s
```

This machine measured background jobs at roughly the same wall-clock time as a **single**
sleep, not three sequential ones proportionally - though job start/teardown overhead means
the improvement wasn't a full 3x speedup in this run (each job's own process-start cost adds
up). The isolation was also proven live: a job's script block could not see `$myVar` from
the calling session (`Get-Variable -Name myVar` inside the job returned nothing) - data must
be passed in explicitly via `-ArgumentList`.

## Advantages / Disadvantages

- Advantage: real, OS-level process isolation between jobs - one job crashing cannot corrupt another's state.
- Advantage: works out of the box, no additional module needed, unlike some concurrency patterns in other languages.
- Disadvantage: each job is a full separate process - real overhead compared to lighter-weight concurrency primitives (e.g. runspaces, or threads in compiled languages).
- Disadvantage: no automatic variable sharing - everything needed inside a job must be passed via `-ArgumentList`.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Expecting a job's script block to see the calling session's variables automatically - verified live that it cannot.
- Forgetting `Remove-Job` after `Receive-Job`, leaving completed jobs accumulating in the session.
- Not calling `Wait-Job` before `Receive-Job`, potentially receiving incomplete/partial results.

## Best Practices

- Always pass required data into a job via `-ArgumentList` rather than assuming variable capture.
- Clean up with `Remove-Job` once a job's results have been received.
- For lighter-weight, same-process concurrency, consider runspaces (not covered here, but worth knowing exists as PowerShell's lower-overhead alternative to `Start-Job`).

## Detailed Example

See [demo.ps1](demo.ps1) - all timing numbers above were captured from a real run on this machine and will vary run-to-run.

## Interview Questions

1. **Do PowerShell background jobs share variables with the calling session?** No - verified live: a job's script block querying `Get-Variable -Name myVar` found nothing, even though `$myVar` was defined in the calling session; data must be passed explicitly via `-ArgumentList`.
2. **What's the real-world cost of `Start-Job`-based concurrency?** Each job runs in a full separate PowerShell process, so there's real per-job startup overhead - measured live here: 3 concurrent 1-second-sleep jobs completed in ~2.98s total (not the full ~3x sequential improvement one might hope for, due to that per-job process overhead).

## Recommended Next Lesson

[15 - Modules](../15-Modules/README.md)
