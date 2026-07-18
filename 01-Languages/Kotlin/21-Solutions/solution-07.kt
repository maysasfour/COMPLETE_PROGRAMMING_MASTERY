// Exercise 07 -- Validated Signup with Result-Style Error Handling

sealed class SignupResult {
    data class Success(val username: String) : SignupResult()
    data class Failure(val reason: String) : SignupResult()
}

fun validateUsername(input: String?): SignupResult {
    // ?.let{} + ?: chains the null/blank checks without a manual `if (input == null)` first --
    // the whole expression naturally falls through to Failure the moment any link returns null.
    val trimmed = input?.trim()?.takeIf { it.isNotEmpty() }
        ?: return SignupResult.Failure(if (input == null) "username is null" else "username is blank")

    return if (trimmed.length < 3) {
        SignupResult.Failure("username '$trimmed' is shorter than 3 characters")
    } else {
        SignupResult.Success(trimmed)
    }
}

// Exhaustive `when` over a sealed class -- the compiler proves these two branches are the
// only possible SignupResult subtypes, so no `else` is needed (and none is written).
fun SignupResult.isSuccess(): Boolean = when (this) {
    is SignupResult.Success -> true
    is SignupResult.Failure -> false
}

fun main() {
    val inputs: List<String?> = listOf(null, "", "ab", "amara", "ben_the_builder")
    val results = inputs.map { validateUsername(it) }

    println("--- all attempts ---")
    for ((input, result) in inputs.zip(results)) {
        val outcome = when (result) {
            is SignupResult.Success -> "SUCCESS: ${result.username}"
            is SignupResult.Failure -> "FAILURE: ${result.reason}"
        }
        println("input=${input?.let { "\"$it\"" } ?: "null"} -> $outcome")
    }

    println("--- successes only (filtered via the isSuccess() extension) ---")
    results.filter { it.isSuccess() }
        .forEach { println((it as SignupResult.Success).username) }
}
