<?php
declare(strict_types=1);
// example.php - classes, interfaces, abstract classes, traits (PHP's answer to "no multiple
// inheritance" -- horizontal code reuse), and enums (PHP 8.1+, genuinely backed and can
// implement interfaces, unlike a plain class-of-constants workaround).

interface Speaker {
    public function speak(): string;
}

abstract class Animal implements Speaker {
    public function __construct(protected string $name) {} // promoted property

    abstract public function speak(): string; // must be implemented by subclasses

    public function describe(): string {
        return "{$this->name} says: " . $this->speak();
    }
}

class Dog extends Animal {
    public function speak(): string { return "Woof!"; }
}

class Cat extends Animal {
    public function speak(): string { return "Meow!"; }
}

$animals = [new Dog("Rex"), new Cat("Whiskers")];
foreach ($animals as $animal) {
    echo $animal->describe(), "\n"; // polymorphism -- describe() calls the overridden speak()
}

echo "\n--- Traits: horizontal code reuse (PHP has no multiple inheritance) ---\n";
trait Loggable {
    public function log(string $message): void {
        echo "[" . static::class . "] {$message}\n";
    }
}

class Service {
    use Loggable; // "inherits" the log() method via composition, not class inheritance
}
(new Service())->log("service started");

echo "\n--- Enums (PHP 8.1+): genuinely typed, can have methods, can implement interfaces ---\n";
enum Status: string {
    case Active = "active";
    case Inactive = "inactive";
    case Pending = "pending";

    public function label(): string {
        return match ($this) {
            Status::Active => "Currently Active",
            Status::Inactive => "No Longer Active",
            Status::Pending => "Awaiting Activation",
        };
    }
}

$status = Status::Active;
echo "{$status->value}: {$status->label()}\n";
echo "from string: " . Status::from("pending")->label() . "\n";

echo "\n--- Static members and readonly properties ---\n";
class Counter {
    private static int $count = 0;
    public function __construct(public readonly int $id) {
        self::$count++;
    }
    public static function total(): int { return self::$count; }
}
new Counter(1);
new Counter(2);
echo "total counters created: " . Counter::total() . "\n";
