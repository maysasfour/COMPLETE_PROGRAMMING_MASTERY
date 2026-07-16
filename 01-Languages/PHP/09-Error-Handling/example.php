<?php
declare(strict_types=1);
// example.php - try/catch/finally, custom exceptions, multi-catch (PHP 8+), and the
// Error/Exception hierarchy split (a genuine PHP-specific design, unlike most languages
// covered so far which have just ONE root throwable type).

function divide(float $a, float $b): float {
    if ($b === 0.0) {
        throw new DivisionByZeroError("cannot divide {$a} by zero");
    }
    return $a / $b;
}

try {
    echo divide(10, 2), "\n";
    echo divide(5, 0), "\n";
} catch (DivisionByZeroError $e) {
    echo "caught: " . $e->getMessage() . "\n";
} finally {
    echo "finally always runs\n";
}

echo "\n--- Custom exception class ---\n";
class InsufficientFundsException extends Exception {
    public function __construct(public readonly float $shortfall) {
        parent::__construct("insufficient funds, short by {$shortfall}");
    }
}

function withdraw(float $balance, float $amount): float {
    if ($amount > $balance) {
        throw new InsufficientFundsException($amount - $balance);
    }
    return $balance - $amount;
}

try {
    withdraw(100.0, 150.0);
} catch (InsufficientFundsException $e) {
    echo $e->getMessage() . " (shortfall property: {$e->shortfall})\n";
}

echo "\n--- Multi-catch (PHP 8+): one catch block, several exception types ---\n";
function risky(int $mode): void {
    match ($mode) {
        1 => throw new InvalidArgumentException("bad argument"),
        2 => throw new RuntimeException("bad runtime state"),
        default => null,
    };
}

foreach ([1, 2] as $mode) {
    try {
        risky($mode);
    } catch (InvalidArgumentException | RuntimeException $e) {
        echo get_class($e) . ": " . $e->getMessage() . "\n";
    }
}

echo "\n--- Error vs Exception: two SEPARATE hierarchies, both implementing Throwable ---\n";
// TypeError, DivisionByZeroError, ArgumentCountError extend Error (programming mistakes,
// usually NOT meant to be caught in normal control flow); Exception and its subclasses
// are for expected, recoverable runtime failures. Both implement the Throwable interface,
// so `catch (Throwable $e)` catches either -- but catching Error broadly is usually a smell.
try {
    strlen(); // ArgumentCountError -- extends Error, not Exception
} catch (Throwable $e) {
    echo get_class($e) . ": " . $e->getMessage() . "\n";
}
