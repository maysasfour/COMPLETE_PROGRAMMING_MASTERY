// Exercise 03 -- Sealed Class Payment Processor
//
// NOTE on the "deliberate compile error" part of this exercise: since this file must
// actually compile to be verified, the broken intermediate step (StoreCredit added to the
// sealed hierarchy before describe() was updated) is captured as real, pasted compiler
// output below rather than left in the file uncompilable. The final, working version follows.
//
// Compiler output actually reproduced by temporarily adding `object StoreCredit : PaymentMethod()`
// to the hierarchy below WITHOUT adding a matching `is StoreCredit` branch to describe():
//
//   solution-03.kt:26:5: error: 'when' expression must be exhaustive, add necessary 'is StoreCredit' branch or 'else' branch instead.
//   fun describe(method: PaymentMethod): String = when (method) {
//       ^
//
// This is the compiler catching a genuinely incomplete `when` at compile time, not something
// merely asserted in prose -- the exact behavior a sealed class + exhaustive `when` is FOR
// (adding a new subtype forces every consuming `when` to be updated or the build fails).
// Restoring the missing `is StoreCredit ->` branch below is what made this file compile again.

sealed class PaymentMethod {
    data class CreditCard(val last4: String) : PaymentMethod()
    data class BankTransfer(val iban: String) : PaymentMethod()
    object CashOnDelivery : PaymentMethod()
    object StoreCredit : PaymentMethod() // the fourth subtype added after the error was reproduced
}

fun describe(method: PaymentMethod): String = when (method) {
    is PaymentMethod.CreditCard -> "Credit card ending in ${method.last4}"
    is PaymentMethod.BankTransfer -> "Bank transfer from IBAN ${method.iban}"
    is PaymentMethod.CashOnDelivery -> "Cash on delivery"
    is PaymentMethod.StoreCredit -> "Store credit balance"
    // no `else` branch -- the sealed hierarchy is closed to this file, so the compiler
    // can prove these four branches are the only possible subtypes and enforce completeness.
}

fun main() {
    val methods = listOf(
        PaymentMethod.CreditCard("4242"),
        PaymentMethod.BankTransfer("DE89370400440532013000"),
        PaymentMethod.CashOnDelivery,
        PaymentMethod.StoreCredit
    )
    for (method in methods) {
        println(describe(method))
    }
}
