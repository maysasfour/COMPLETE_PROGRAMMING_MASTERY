<?php

declare(strict_types=1);

/**
 * Exercise 02 — Traits and a Real Conflict Resolution
 *
 * Two traits that are individually useful but collide on a method name.
 * PHP resolves this at compile time via `insteadof`/`as` in the *using*
 * class -- neither trait needs to know about the other, which is the
 * whole point of traits as horizontal (non-hierarchical) code reuse.
 */
trait Greetable
{
    public function describe(): string
    {
        return "Hi, I'm a " . static::class . ".";
    }
}

trait Auditable
{
    public function describe(): string
    {
        return static::class . " last audited: 2026-07-18T00:00:00";
    }
}

final class Volunteer
{
    use Greetable, Auditable {
        // Both traits define describe() -- without this block, PHP would
        // raise a fatal "trait method collision" error at class-definition
        // time rather than silently picking one, since silently picking one
        // could hide a real bug where the "wrong" implementation wins.
        Auditable::describe insteadof Greetable;
        Greetable::describe as greetOnly;
    }
}

// No conflict at all here -- Robot only pulls in one trait, proving traits
// mix into completely unrelated classes with zero shared inheritance chain.
final class Robot
{
    use Greetable;
}

$v = new Volunteer();
echo $v->describe() . "\n";   // Auditable's version won the collision
echo $v->greetOnly() . "\n";  // Greetable's version, reachable via its alias

$r = new Robot();
echo $r->describe() . "\n";   // Robot never touched Auditable at all
