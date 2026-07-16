// main.rs - structs+impl, explicit trait implementation, trait default methods, composition.

struct Animal {
    name: String,
}

impl Animal {
    fn new(name: &str) -> Self {
        Animal { name: name.to_string() }
    }
}

trait Speaker {
    fn speak(&self) -> String;
}

impl Speaker for Animal {
    fn speak(&self) -> String {
        format!("{} makes a sound", self.name)
    }
}

fn announce(s: &impl Speaker) {
    println!("{}", s.speak());
}

trait Greet {
    fn name(&self) -> String;
    fn greeting(&self) -> String {
        format!("Hello, {}!", self.name())
    }
}

impl Greet for Animal {
    fn name(&self) -> String {
        self.name.clone()
    }
    // greeting() is NOT overridden -- uses the trait's default implementation
}

struct Dog {
    animal: Animal,
    breed: String,
}

impl Dog {
    fn speak(&self) -> String {
        format!("{} (a {})", self.animal.speak(), self.breed)
    }
}

fn main() {
    println!("--- struct with impl ---");
    let rex = Animal::new("Rex");
    println!("{}", rex.speak());

    println!("\n--- explicit trait implementation, used generically ---");
    announce(&rex);

    println!("\n--- trait default method, not overridden ---");
    println!("{}", rex.greeting());

    println!("\n--- composition, not inheritance/embedding ---");
    let dog = Dog {
        animal: Animal::new("Fido"),
        breed: "Labrador".to_string(),
    };
    println!("{}", dog.speak());
    println!("accessing through the field explicitly: {}", dog.animal.name);
}
