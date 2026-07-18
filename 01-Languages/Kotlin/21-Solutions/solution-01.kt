// Exercise 01 -- Null-Safe Contact Lookup

data class Contact(val name: String, val email: String?, val phone: String?)

// `?:` chains left-to-right and short-circuits on the first non-null value --
// exactly the fallback semantics this function needs, with no branching keyword at all.
fun bestContactMethod(contact: Contact): String =
    contact.email ?: contact.phone ?: "no contact info"

// `?.let { }` only runs the lambda when the receiver is non-null, so the whole
// expression naturally evaluates to null (not a thrown exception) when email is absent --
// the split() call inside is then safe against a null receiver by construction, not by a runtime check.
fun emailDomain(contact: Contact): String? =
    contact.email?.let { it.substringAfter("@", missingDelimiterValue = "") }
        ?.takeIf { it.isNotEmpty() }

fun main() {
    val withEmail = Contact("Amara", "amara@example.com", null)
    val withPhone = Contact("Ben", null, "555-0100")
    val withNeither = Contact("Cleo", null, null)

    println("--- bestContactMethod ---")
    println("${withEmail.name}: ${bestContactMethod(withEmail)}")
    println("${withPhone.name}: ${bestContactMethod(withPhone)}")
    println("${withNeither.name}: ${bestContactMethod(withNeither)}")

    println("--- emailDomain ---")
    println("${withEmail.name}: ${emailDomain(withEmail)}")
    println("${withPhone.name}: ${emailDomain(withPhone)}")
    println("${withNeither.name}: ${emailDomain(withNeither)}")
}
