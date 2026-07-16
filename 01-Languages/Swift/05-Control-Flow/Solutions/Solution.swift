// NOT COMPILED/RUN -- see course README for the disclosed reason.

func fizzbuzz(_ n: Int) -> String {
    switch n {
    case _ where n % 15 == 0:
        return "FizzBuzz"
    case _ where n % 3 == 0:
        return "Fizz"
    case _ where n % 5 == 0:
        return "Buzz"
    default:
        return String(n)
    }
}

for i in 1...15 {
    print(fizzbuzz(i))
}

// Expected output (based on standard FizzBuzz logic, not verified by execution):
// 1
// 2
// Fizz
// 4
// Buzz
// Fizz
// 7
// 8
// Fizz
// Buzz
// 11
// Fizz
// 13
// 14
// FizzBuzz
