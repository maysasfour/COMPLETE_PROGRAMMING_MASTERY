// Exercise: write a function with a distinct argument label and parameter name,
// a variadic average function, and use trailing closure syntax with $0.
// NOT COMPILED/RUN -- see course README for the disclosed reason.

func average(of numbers: Double...) -> Double {
    // TODO: implement using numbers.reduce(0, +) / Double(numbers.count)
    return 0.0
}

func isPrime(_ n: Int) -> Bool {
    // TODO: implement -- return false for n < 2, check divisibility up to sqrt(n)
    return false
}

let primes = (2...30).filter { isPrime($0) }
print("primes up to 30: \(primes)") // expected: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
print("average: \(average(of: 1.0, 2.0, 3.0, 4.0))") // expected: 2.5
