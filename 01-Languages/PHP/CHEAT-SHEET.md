# PHP Cheat Sheet

[Back to course overview](README.md)

## Variables and Types (Dynamic)

```php
$age = 30;               // int
$price = 19.99;            // float
$name = "Ada";               // string
$active = true;                // bool
gettype($age);                   // "integer"
var_dump($age);                    // int(30) -- shows real type + value

define("MAX", 100);   // classic constant
const MIN = 1;           // modern constant (top-level or class only)
```

## `==` vs `===` (Use `===`!)

```php
0 == "abc";     // false on PHP 8+ (was true on PHP 7)
"0" == 0;         // true  -- STILL true on PHP 8! ("0" is a numeric string)
1 === "1";          // false -- strict requires same type too
```

## Operators

```php
2 ** 10;            // exponentiation: 1024
intdiv(10, 3);        // integer division: 3
1 <=> 2;                // spaceship: -1 / 0 / 1
$user->address?->city ?? "default"; // null-safe + null coalescing
$a = true && false;      // use &&/||, NOT and/or (different precedence vs =!)
```

## Control Flow

```php
if ($x > 0) { } elseif ($x == 0) { } else { }

switch ($x) {
    case 1: case 2: echo "one or two"; break; // falls through without break!
    default: echo "other";
}

$result = match ($x) {           // PHP 8+: expression, STRICT (===), no fall-through
    1, 2 => "one or two",
    default => "other",
};

for ($i = 0; $i < 3; $i++) { }
foreach ($arr as $key => $value) { }
```

## Functions

```php
function greet(string $name, string $greeting = "Hi"): string {
    return "{$greeting}, {$name}!";
}
greet(name: "Ada", greeting: "Hello"); // named args (PHP 8+), order-independent

function sum(int ...$nums): int { return array_sum($nums); } // variadic

function increment(int &$n): void { $n++; } // by-reference param -- mutates caller's var!

$triple = fn($x) => $x * 3;        // arrow fn: auto-captures outer scope
$add = function ($a) use ($outer) { return $a + $outer; }; // needs explicit use()

array_map(strtoupper(...), $words); // first-class callable syntax (PHP 8.1+)
```

## Collections (ONE `array` type -- list AND map)

```php
$list = [1, 2, 3];
$map = ["name" => "Ada", "age" => 30];   // same `array` type

array_map(fn($x) => $x * 2, $list);
array_filter($list, fn($x) => $x > 1);    // PRESERVES original keys! use array_values() after
array_reduce($list, fn($c, $x) => $c + $x, 0);

[$a, $b, $c] = $list;                       // destructuring
$combined = [...$list, ...[4, 5]];          // spread
sort($list);                                  // MUTATES in place, returns bool not the array
```

## Strings

```php
strtoupper($s); str_replace("a", "b", $s); substr($s, 0, 3);
str_contains($s, "x"); str_starts_with($s, "x"); str_ends_with($s, "x"); // PHP 8+

strlen($s);     // BYTE length
mb_strlen($s);   // CHARACTER length (needs mbstring extension)

$h = <<<EOT
Interpolates {$name}, like double quotes.
EOT;
$n = <<<'EOT'
Does NOT interpolate {$name}, like single quotes.
EOT;
```

## Error Handling

```php
try {
    riskyOp();
} catch (SpecificException | AnotherException $e) { // multi-catch (PHP 8+)
    echo $e->getMessage();
} finally {
    echo "always runs";
}

class MyException extends Exception {
    public function __construct(public readonly float $extra) {
        parent::__construct("custom message");
    }
}
// Error (TypeError, ArgumentCountError, DivisionByZeroError) and Exception are
// SEPARATE hierarchies, both implementing Throwable -- catch(Exception) misses Errors!
```

## OOP

```php
interface Speaker { public function speak(): string; }

abstract class Animal implements Speaker {
    public function __construct(protected string $name) {} // promoted property
    abstract public function speak(): string;
}

trait Loggable { public function log($msg) { echo $msg; } } // horizontal reuse
class Service { use Loggable; }

enum Status: string {          // PHP 8.1+ backed enum
    case Active = "active";
    case Inactive = "inactive";
    public function label(): string { return match($this) { self::Active => "On", self::Inactive => "Off" }; }
}
Status::from("active")->label();
```

## No Generics

```php
// No <T> syntax at all. Options:
function push(mixed $item): void {}          // no safety at all
/** @template T @param T $item */             // PHPStan/Psalm ONLY -- zero runtime effect
function pushTyped(mixed $item): void {}
interface Comparable { public function compareTo(Comparable $o): int; } // real, runtime-enforced
```

## Async/Concurrency

```php
$fiber = new Fiber(function () {
    Fiber::suspend("paused");   // cooperative -- NOT parallelism
});
$fiber->start();
$fiber->resume();

// Real concurrent I/O despite single-threaded PHP:
$mh = curl_multi_init();
curl_multi_add_handle($mh, $ch1);
curl_multi_add_handle($mh, $ch2);
do { curl_multi_exec($mh, $running); } while ($running > 0);
```

## Namespaces and Autoloading

```php
namespace App;
use App\Other\Thing as T;

spl_autoload_register(function ($class) {
    // PSR-4: map namespace prefix -> directory, load lazily
});
```

```json
// composer.json
{ "autoload": { "psr-4": { "App\\": "src/" } } }
```

## Database (PDO)

```php
$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = :id"); // ALWAYS parameterize
$stmt->execute(["id" => $id]);
$stmt->fetch(PDO::FETCH_ASSOC);
```

## HTTP / JSON

```php
$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);           // NO exception on 404 -- check curl_getinfo(HTTP_CODE)!

json_encode($data, JSON_PRETTY_PRINT); // built in, no library needed
json_decode($json, true);                // true = associative array
```

## Testing (PHPUnit)

```php
final class MyTest extends TestCase {
    protected function setUp(): void { /* runs before EVERY test */ }

    #[Test]
    public function itWorks(): void { $this->assertSame(4, 2 + 2); }

    #[Test]
    #[DataProvider('cases')]
    public function tableDriven(int $a, int $b, int $expected): void {
        $this->assertSame($expected, $a + $b);
    }
    public static function cases(): array { return ["1+1" => [1, 1, 2]]; }
}
```

## Running Code

```bash
php script.php               # no build step, runs directly
php phpunit.phar tests/       # PHPUnit, downloaded standalone (no Composer needed)
```
