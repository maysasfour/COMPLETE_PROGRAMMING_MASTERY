<?php
declare(strict_types=1);
// example.php - PHP has NO real generics (no <T> syntax at all, unlike Java/C#/Go/Rust/TS).
// This lesson shows the honest workarounds: `mixed`/duck typing, interface-based constraints,
// and PHPDoc generic annotations (@template) understood by static analyzers (PHPStan/Psalm)
// but NOT enforced by the PHP runtime itself -- a real, load-bearing distinction.

echo "--- Without generics: a 'generic-looking' Stack using `mixed` -- no type safety at all ---\n";
class Stack {
    private array $items = [];
    public function push(mixed $item): void { $this->items[] = $item; }
    public function pop(): mixed { return array_pop($this->items); }
    public function isEmpty(): bool { return empty($this->items); }
}
$stack = new Stack();
$stack->push(1);
$stack->push("oops, a string in an int stack -- PHP's runtime does NOT catch this");
echo $stack->pop(), "\n"; // no error at all -- mixed accepts anything
echo $stack->pop(), "\n";

echo "\n--- PHPDoc @template: static analyzers (PHPStan/Psalm) understand this, PHP itself doesn't ---\n";
/**
 * @template T
 */
class TypedStack {
    /** @var T[] */
    private array $items = [];

    /** @param T $item */
    public function push(mixed $item): void { $this->items[] = $item; }

    /** @return T */
    public function pop(): mixed { return array_pop($this->items); }
}
// A static analyzer configured with this class as TypedStack<int> would FLAG pushing a
// string as a type error at analysis time -- but running this file with plain `php` performs
// NO such check; the @template annotation is pure documentation to the PHP runtime itself.
$typedStack = new TypedStack();
$typedStack->push(42);
echo $typedStack->pop(), "\n"; // works fine at runtime regardless of what a static analyzer would say

echo "\n--- Interface-based constraints: the REAL, enforced alternative ---\n";
// A genuine, verified gotcha hit while writing this example: declaring the interface
// method as `compareTo(self $other)` and implementing it as `compareTo(self $other)`
// STILL fails with "must be compatible" -- because `self` resolves to Comparable in the
// interface's own scope and to Money in Money's scope, and PHP requires INVARIANT parameter
// types (no narrowing allowed), so the two `self`s are considered different, incompatible
// types. The fix is to type the parameter as the interface itself, not `self`:
interface Comparable {
    public function compareTo(Comparable $other): int;
}

class Money implements Comparable {
    public function __construct(public readonly int $cents) {}
    public function compareTo(Comparable $other): int {
        // $other is only guaranteed to be *a* Comparable, not specifically a Money --
        // an explicit runtime check (or a manual cast) is needed for type-specific access.
        if (!$other instanceof Money) {
            throw new InvalidArgumentException("can only compare Money to Money");
        }
        return $this->cents <=> $other->cents;
    }
}

function findMax(array $items): mixed { // no <T extends Comparable> possible -- just `array`
    $max = $items[0];
    foreach ($items as $item) {
        if ($item->compareTo($max) > 0) { $max = $item; }
    }
    return $max;
}
$amounts = [new Money(500), new Money(1200), new Money(300)];
$max = findMax($amounts);
echo "max: {$max->cents} cents\n"; // 1200 -- this interface-based check IS enforced at runtime
