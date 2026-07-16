# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define classes with constructors, destructors, and inheritance.
- Use `virtual` functions for polymorphism, and understand why it must be explicit (like C#, unlike Java).
- Understand the **slicing** problem when a derived object is copied into a base-by-value variable.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md) and [10-File-Handling](../10-File-Handling/README.md)

## Concept

C++ classes require `virtual` to be explicit for polymorphic dispatch — like C#, unlike Java's overridable-by-default model. Because C++ has value semantics by default (Lesson 03), polymorphism through a base-class **value** (not reference/pointer) is fundamentally broken by **slicing** — a problem that simply cannot occur in Java/C#, where everything non-primitive is already a reference.

## Classes, Constructors, Destructors, Inheritance

```cpp
class Animal {
    std::string name;
public:
    Animal(const std::string& name) : name(name) {} // member initializer list
    virtual std::string speak() const { return name + " makes a sound"; } // virtual -- explicit, required
    virtual ~Animal() = default; // virtual destructor -- REQUIRED for safe polymorphic deletion
};

class Dog : public Animal {
public:
    Dog(const std::string& name) : Animal(name) {}
    std::string speak() const override { return "Woof"; } // override -- optional but strongly conventional
};
```

A **virtual destructor** in the base class is not optional if you ever `delete` a derived object through a base-class pointer — without it, only the base class's destructor runs, leaking any derived-class resources. This is a distinctly C++ concern with no equivalent in garbage-collected languages.

## Slicing: The Value-Semantics Polymorphism Trap

```cpp
Dog dog("Rex");
Animal animalByValue = dog;      // SLICED: only the Animal portion is copied
std::cout << animalByValue.speak(); // "Rex makes a sound" -- NOT "Woof"! Dog-ness is gone.

Animal& animalByRef = dog;         // NOT sliced -- a reference to the full Dog object
std::cout << animalByRef.speak();   // "Woof" -- correct polymorphic dispatch
```

This cannot happen in Java or C# — assigning a `Dog` to an `Animal`-typed variable there just copies a reference to the same full object. In C++, only references or pointers preserve polymorphic behavior; passing/assigning by value silently discards it.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints correct polymorphic dispatch through a reference, and demonstrates slicing concretely — the sliced value's `speak()` call proves it lost its `Dog`-specific behavior.

## Common Mistakes

- Forgetting `virtual` on a base class method intended to be overridden — without it, calls through a base pointer/reference always invoke the base version, regardless of the actual object's type.
- Forgetting a `virtual` destructor on a polymorphic base class — `delete`-ing a derived object through a base pointer without one causes only the base destructor to run, leaking derived-class resources.
- Passing/storing polymorphic objects by value, triggering slicing — always use references or pointers (commonly smart pointers, Lesson 19) for polymorphic types.

## Best Practices

- Always give a polymorphic base class a `virtual` destructor.
- Always use references or pointers (never plain by-value parameters/variables) for any type meant to be used polymorphically.
- Use `override` on every overriding method — like C#, it's a compile error if the method doesn't actually match a `virtual` base signature, catching typos.

## Real-World Usage

The slicing problem is one of the most C++-specific bugs in this entire repository's language courses — a function accidentally taking a base class parameter by value instead of by reference silently and quietly discards all derived behavior, a bug that's easy to introduce and can be subtle to spot in review.

## Summary

- `virtual` (explicit, like C#) enables polymorphic dispatch; a `virtual` destructor is mandatory for any polymorphic base class deleted through a base pointer.
- Slicing occurs when a derived object is copied/assigned by value into a base-typed variable, discarding derived-specific data and behavior — a direct consequence of C++'s default value semantics that has no equivalent in Java/C#.
- Always use references or pointers, never by-value, for polymorphic types.

## Key Terms

- **Slicing** — copying only the base-class portion of a derived object when assigned/passed by value to a base-typed variable/parameter.
- **Virtual destructor** — a `virtual ~ClassName()` on a polymorphic base class, required for correct cleanup when deleting a derived object through a base pointer.

## Review Questions

1. Why does `Animal a = dog;` lose `Dog`'s overridden behavior, while `Animal& a = dog;` doesn't?
2. What goes wrong if a polymorphic base class's destructor isn't `virtual`?
3. Why doesn't slicing exist as a concept in Java or C#?

## Interview Questions

1. **What is "slicing" in C++, and why can't it happen in Java or C#?**
   Slicing occurs when a derived-class object is assigned or passed by value to a base-class-typed variable/parameter — only the base-class portion of the object's memory layout is copied, discarding derived-specific fields and the object's actual polymorphic identity (subsequent virtual calls on the sliced copy use the base class's behavior, not the original derived class's). It can't happen in Java/C# because those languages have reference semantics for all non-primitive types by default — assigning a derived instance to a base-typed variable just copies a reference to the same complete object, never a partial copy.

2. **Why must a polymorphic base class have a virtual destructor?**
   If a derived object is deleted through a base-class pointer (`Animal* a = new Dog(); delete a;`) and the base destructor isn't `virtual`, only the base class's destructor runs — any resources the derived class's destructor would have released (dynamically allocated memory, open handles) are leaked, since the compiler statically resolves which destructor to call based on the pointer's declared type, not the object's actual type, unless `virtual` enables dynamic dispatch for the destructor too.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
