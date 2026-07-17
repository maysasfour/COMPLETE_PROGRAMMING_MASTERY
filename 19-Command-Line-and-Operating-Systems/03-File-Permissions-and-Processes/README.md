# 03 — File Permissions and Processes

[Back to module overview](../README.md) | [Previous: PowerShell Basics](../02-PowerShell-Basics/README.md)

## Beginner: Permission Bits, Verified Live — Including a Real Platform Difference

Unix-style file permissions (`chmod`) and process management (`ps`/`kill`) are foundational OS concepts. This lesson demonstrates both live — and discloses a genuinely interesting, real finding discovered while doing so: **`chmod`'s enforcement is filesystem-dependent**, and on this session's Windows/NTFS + Git Bash (MSYS) environment, it behaves differently than on a native Linux system.

## `chmod`, Verified Live — And a Real, Disclosed Surprise

```bash
chmod +x greet.sh
stat -c "%a %n" greet.sh   # 755
./greet.sh                  # runs fine, exit code 0

chmod 600 greet.sh          # remove execute AND write/other-read permissions
stat -c "%a %n" greet.sh
./greet.sh
```

On a real Linux system with a native (ext4-style) filesystem, this second `./greet.sh` would fail with `Permission denied`, since `600` removes the execute bit entirely. Verified live, **on this specific Windows/NTFS + Git Bash environment**:

```
Reported permissions after chmod 600:
755 greet.sh
Attempting to run it anyway:
Hello from greet.sh
exit code: 0
```

`stat` still reports `755` even after `chmod 600`, and the script still runs successfully. This is a genuine, verified finding, not a mistake in this lesson: NTFS has no native concept of Unix permission bits, and Git Bash's `chmod`/`stat` on an NTFS-mounted path are largely cosmetic — they don't map onto real, enforced access control the way they would on a native Linux filesystem. **This is exactly the kind of platform-dependent behavior worth knowing about directly, rather than assuming a command behaves identically everywhere it's available.**

## Process Management, Verified Live — Safely, by Exact PID

```bash
sleep 60 &
BGPID=$!
ps -p $BGPID
kill $BGPID
ps -p $BGPID   # confirms it's gone
```

Verified live:

```
Started a real background process with PID: 3529
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
     3529    3521    3517      38972  ?         197609 03:36:50 /usr/bin/sleep
Killing it by that exact PID:
Confirming it is genuinely gone (a non-zero exit code below means gone):
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
```

The second `ps -p` call produced no matching row and a non-zero exit code — genuine confirmation the process was killed. This mirrors the safe process-management discipline established elsewhere in this repository (see [04-Backend-Development](../../04-Backend-Development/README.md)'s server lessons): **always target an exact, verified PID — never kill by image/process name**, which risks affecting unrelated processes sharing that name.

## Detailed Example

See [demo.sh](demo.sh) — every command above, runnable end-to-end.

## Run It

```bash
bash demo.sh
```

## Expected Output

`chmod`/`stat` output showing this platform's actual (non-enforcing) behavior; a background process started, listed by its exact PID, killed, and confirmed gone via a non-zero `ps` exit code.

## Common Mistakes

- Assuming `chmod` behaves identically on every filesystem/platform — verified live on this environment that it does not meaningfully restrict execution on an NTFS-backed path via Git Bash, unlike a native Linux filesystem.
- Killing processes by name (`pkill processname`, `taskkill /IM name.exe`) instead of by a specific, verified PID — this risks affecting other, unrelated processes that happen to share the same name.
- Not verifying a process was actually killed — this lesson explicitly re-checks with `ps -p $BGPID` afterward, confirming via its exit code rather than assuming `kill` succeeded.

## Best Practices

- Understand that permission enforcement is a property of the underlying filesystem and OS, not just the `chmod` command itself — verify actual behavior on your real target platform rather than assuming textbook Linux behavior applies everywhere.
- Always capture and target an exact PID when managing processes programmatically, verifying both before and after any kill operation.
- When genuinely testing Unix permission enforcement, use a real native Linux filesystem (a real Linux machine, a properly configured WSL distribution, or a container) rather than assuming a Windows/NTFS environment behaves identically.

## Real-World Usage

Real production incident response and automation scripts routinely need to safely identify and terminate specific processes without affecting unrelated ones sharing a name — exactly the PID-verified approach demonstrated here and used throughout this repository's own server-management lessons. The `chmod`/filesystem discovery in this lesson reflects a genuinely common real-world gotcha: scripts developed and tested on Windows (via Git Bash or WSL with certain filesystem mounts) can behave differently once deployed to a real Linux production server, specifically around permission enforcement.

## Summary

- `chmod`'s effect was verified live to be filesystem-dependent: on this session's Windows/NTFS + Git Bash environment, permission bits did not actually restrict script execution, a genuine and disclosed platform difference from native Linux behavior.
- Process management was verified live to work safely and correctly: a real background process was started, listed by its exact PID, killed, and confirmed gone via a non-zero exit code on re-check.

## Key Terms

- **`chmod`** — the Unix command for changing a file's permission bits (read/write/execute for owner/group/other).
- **PID (Process ID)** — a unique identifier for a running process, the safe way to target a specific process for inspection or termination.
- **Filesystem-dependent behavior** — a command or feature whose actual effect depends on the underlying filesystem/OS, not just the command's documented behavior in the abstract.

## Interview Questions

1. **Why might `chmod`'s effect differ between platforms, and how was this demonstrated concretely in this lesson?**
   Unix permission bits are a POSIX filesystem concept — enforcement depends on the underlying filesystem actually implementing and honoring those bits. NTFS (Windows' native filesystem) has its own, different access-control model (ACLs), and tools like Git Bash's `chmod`/`stat` running on an NTFS-mounted path may not translate cleanly into real, enforced restrictions. This was demonstrated concretely: after running `chmod 600 greet.sh` (which should remove execute permission entirely), `stat` still reported `755`, and the script still executed successfully with exit code `0` — a real, verified difference from the `Permission denied` failure that would occur on a native Linux filesystem.

2. **Why is targeting an exact PID considered safer than killing a process by name, and how was this demonstrated?**
   Killing by name risks matching and terminating unrelated processes that happen to share that name — a real, serious risk on shared or busy systems. Targeting a specific, captured PID guarantees only the intended process is affected. This was demonstrated concretely: `BGPID=$!` captured the exact process ID of a real background `sleep` process immediately after starting it, `ps -p $BGPID` confirmed that exact process was running, `kill $BGPID` terminated only that process, and a follow-up `ps -p $BGPID` returning no results (non-zero exit code) confirmed it was genuinely gone — without any risk of affecting some other, unrelated `sleep` process that might have been running concurrently.

## Recommended Next Lesson

This is the final lesson in the Command Line and Operating Systems module. Continue to [20-Computer-Science-Fundamentals](../../20-Computer-Science-Fundamentals/README.md) if built, or return to the [module overview](../README.md).
