// solution-06.cpp - Exercise 06: a shared_ptr reference cycle, reproduced live, then
// broken with a weak_ptr back-reference.
#include <iostream>
#include <memory>
#include <vector>
#include <string>

// --- Version 1: Parent <-> Child both hold shared_ptr to each other -> a real cycle ---
namespace cyclic {
    struct Parent;

    struct Child {
        std::string name;
        std::shared_ptr<Parent> parent; // shared_ptr back-reference -- this is the bug
        explicit Child(std::string n) : name(std::move(n)) {}
        ~Child() { std::cout << "  Child '" << name << "' destroyed" << std::endl; }
    };

    struct Parent {
        std::string name;
        std::vector<std::shared_ptr<Child>> children;
        explicit Parent(std::string n) : name(std::move(n)) {}
        ~Parent() { std::cout << "  Parent '" << name << "' destroyed" << std::endl; }
    };

    void demo() {
        std::cout << "--- cyclic version: Parent and Child both own each other via shared_ptr ---" << std::endl;
        {
            auto parent = std::make_shared<Parent>("root");
            auto child = std::make_shared<Child>("leaf");
            parent->children.push_back(child);
            child->parent = parent; // now parent and child each hold a shared_ptr to the other

            std::cout << "  parent use_count: " << parent.use_count()
                      << " (1 local + 1 from child->parent)" << std::endl;
            std::cout << "  child use_count: " << child.use_count()
                      << " (1 local + 1 from parent->children)" << std::endl;
            std::cout << "  leaving scope now..." << std::endl;
        }
        // Neither destructor printed above -- both objects leaked. Each one's reference
        // count never reaches zero: parent is kept alive by child->parent, and child is
        // kept alive by parent->children, even though nothing outside this scope holds
        // either anymore. This is exactly why shared_ptr cycles are a real, live footgun.
        std::cout << "  (no destructor messages above this line -- both objects LEAKED, a true reference cycle)" << std::endl;
    }
}

// --- Version 2: Child holds weak_ptr<Parent> instead -> breaks the cycle ---
namespace fixed {
    struct Parent;

    struct Child {
        std::string name;
        std::weak_ptr<Parent> parent; // weak_ptr does NOT contribute to the use_count
        explicit Child(std::string n) : name(std::move(n)) {}
        ~Child() { std::cout << "  Child '" << name << "' destroyed" << std::endl; }

        void greetParent() const;
    };

    struct Parent {
        std::string name;
        std::vector<std::shared_ptr<Child>> children;
        explicit Parent(std::string n) : name(std::move(n)) {}
        ~Parent() { std::cout << "  Parent '" << name << "' destroyed" << std::endl; }
    };

    void Child::greetParent() const {
        // .lock() promotes the weak_ptr to a temporary shared_ptr ONLY if the Parent
        // still exists -- checking for null is mandatory, unlike a raw pointer where
        // it's easy to forget and get a dangling-pointer bug instead of a safe null.
        if (auto p = parent.lock()) {
            std::cout << "  " << name << "'s parent is still alive: " << p->name << std::endl;
        } else {
            std::cout << "  " << name << "'s parent is already gone" << std::endl;
        }
    }

    void demo() {
        std::cout << "\n--- fixed version: Child holds weak_ptr<Parent> instead ---" << std::endl;
        std::shared_ptr<Child> survivingChild;
        {
            auto parent = std::make_shared<Parent>("root");
            auto child = std::make_shared<Child>("leaf");
            parent->children.push_back(child);
            child->parent = parent; // weak_ptr assignment -- does not bump use_count

            std::cout << "  parent use_count: " << parent.use_count()
                      << " (only 1 -- child's weak_ptr doesn't count)" << std::endl;
            child->greetParent();
            survivingChild = child; // keep the child alive past this scope, parent doesn't
            std::cout << "  leaving scope now..." << std::endl;
        }
        // Parent's destructor DOES run here, immediately -- its use_count correctly hit
        // zero once the local `parent` shared_ptr went out of scope, because the only
        // other reference to it (child->parent) was a non-owning weak_ptr.
        std::cout << "  (Parent destructor message above -- cycle broken)" << std::endl;
        survivingChild->greetParent(); // parent is gone now; .lock() safely returns null
    }
}

int main() {
    cyclic::demo();
    fixed::demo();
    return 0;
}
