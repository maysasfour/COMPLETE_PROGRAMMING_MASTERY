# 15 — Modules and Packages (`+package` Namespace Folders)

[Back to course overview](../README.md) | [Previous: Concurrency](../14-Concurrency/README.md) | [Next: Database Access](../16-Database-Access/README.md)

## What / Why / Where

MATLAB has no `import`/`require`/`module` keyword the way Python or JavaScript do. Instead, it uses **folders whose name starts with `+`** as namespaces. Any `.m` function file or `classdef` placed inside a `+foldername/` directory is automatically namespaced under `foldername`, callable only as `foldername.functionname(...)` (never bare `functionname(...)`). This is MATLAB's answer to "how do I avoid name collisions and group related functions" — used heavily in real MATLAB toolboxes (e.g. `matlab.io.*`, `matlab.net.http.*`) to organize large codebases without polluting the global function namespace.

Namespaces can nest: `+geometry/+shapes/square_area.m` is called as `geometry.shapes.square_area(...)`.

**Verified in this course with GNU Octave 9.2.0** (see [01-Setup](../01-Setup/) and the disclosure in the [course README](../README.md)) — the prior session's open question ("does this genuinely work in Octave?") is now answered: **yes**, Octave implements `+package` folders identically to MATLAB, for both plain functions and `classdef` files. This was confirmed by actually running the demo below, not assumed.

## Folder Structure in This Lesson

```
15-Modules-and-Packages/
├── +geometry/
│   ├── circle_area.m            % geometry.circle_area(r)
│   ├── circle_circumference.m   % geometry.circle_circumference(r)
│   ├── Point.m                  % geometry.Point(x,y) - a classdef IS namespaced too
│   └── +shapes/
│       └── square_area.m        % geometry.shapes.square_area(side) - nested namespace
└── pkg_demo.m                    % script that exercises all of the above
```

The leading `+` is a filesystem convention read by MATLAB/Octave's path resolver — it is never typed when calling the function, and the folder must be on the MATLAB path (or you must `cd` to its parent), exactly like the demo script below does implicitly by living next to `+geometry/`.

## Beginner: Calling a Namespaced Function

```matlab
% From pkg_demo.m
fprintf('circle_area(2) via package  = %.4f\n', geometry.circle_area(2));
```

## Intermediate: Nested Namespaces and Namespaced Classes

```matlab
fprintf('shapes.square_area(3) (nested pkg) = %.4f\n', geometry.shapes.square_area(3));

p = geometry.Point(3, 4);
fprintf('geometry.Point(3,4).distance_to_origin() = %.4f\n', p.distance_to_origin());
```

`geometry.Point` is a `classdef` file living inside `+geometry/Point.m` — placing a class inside a package folder namespaces the class itself, not just plain functions.

## Advanced: What Happens Without the Package Prefix

A function inside a `+package` folder genuinely **does not exist** in the base workspace — calling it unqualified fails, which is the whole point (collision avoidance):

```matlab
try
  circle_area(2);
catch err
  fprintf('Expected failure calling unqualified circle_area(2): %s\n', err.message);
end
```

## Real, Captured Run

```
$ octave-cli pkg_demo.m
circle_area(2) via package  = 12.5664
circle_circumference(2)     = 12.5664
shapes.square_area(3) (nested pkg) = 9.0000
geometry.Point(3,4).distance_to_origin() = 5.0000
Expected failure calling unqualified circle_area(2): 'circle_area' undefined near line 15, column 3
```

(`circle_area(2)` and `circle_circumference(2)` land on the same value, 12.5664, only by numeric coincidence: `pi*2^2 == 2*pi*2 == 4*pi`.)

## What MATLAB Also Has That This Lesson Doesn't Demonstrate

- **`classdef` with `Access = private/protected`** for encapsulation within a class — covered in [Lesson 11 — OOP](../11-OOP/README.md), orthogonal to namespacing.
- **MATLAB Projects (`.prj`) / toolbox packaging (`.mltbx`)** — a GUI-driven, paid-MATLAB-only mechanism for bundling a whole set of packages, path entries, and metadata into one distributable file. Not available in Octave and not verifiable here — mentioned for completeness, not demonstrated.
- **Namespaced constants/enumerations** — an `enumeration` block inside a `classdef` in a `+package` folder is also namespaced the same way; not separately demonstrated since it follows directly from the `Point` example.

## Common Beginner Mistakes

- Typing the `+` when calling: `+geometry.circle_area(2)` is a syntax error — the `+` is a folder-naming convention only, never part of the call.
- Forgetting that the parent directory *containing* `+geometry/` (not `+geometry/` itself) must be on the path/current folder — adding `+geometry/` directly to the path breaks the namespace.
- Assuming private helper functions inside a package folder are hidden — every `.m` file directly inside `+geometry/` is public and callable as `geometry.thatfile(...)`; true privacy requires a [private/ subfolder](https://docs.octave.org) or `classdef` access modifiers instead.

## Best Practices

- Group functions by domain (`+geometry`, `+validation`, `+io`) the same way you'd group modules in Python — one namespace per cohesive responsibility.
- Prefer namespaces over ad hoc prefixes (`geometry_circle_area`) once a project passes roughly half a dozen related functions — it is the idiomatic MATLAB equivalent of Python packages/JS modules.
- Keep `classdef`s that belong to a namespace's domain inside that namespace's folder (as `Point.m` is here), rather than scattering related types across the top level.

## Interview Questions

1. How does MATLAB implement namespacing without an `import` keyword? *(Folders prefixed with `+`; the folder name becomes the dotted namespace prefix.)*
2. What happens if you call a `+package` function without its prefix? *(`undefined` error — it is genuinely not present in the base workspace.)*
3. Can a `classdef` be namespaced the same way as a plain function? *(Yes — placing the `.m` class file inside a `+package` folder namespaces the class too, as shown with `geometry.Point`.)*
4. Do namespaces nest? *(Yes: `+outer/+inner/func.m` → `outer.inner.func(...)`.)*

## Suggested Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
