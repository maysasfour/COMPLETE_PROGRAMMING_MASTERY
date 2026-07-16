// NOT COMPILED/RUN -- see course README for the disclosed reason.

func average(of numbers: Double...) -> Double {
    return numbers.reduce(0, +) / Double(numbers.count)
}

func isPrime(_ n: Int) -> Bool {
    if n < 2 { return false }
    var i = 2
    while i * i <= n {
        if n % i == 0 { return false }
        i += 1
    }
    return true
}

let primes = (2...30).filter { isPrime($0) }
print("primes up to 30: \(primes)")
print("average: \(average(of: 1.0, 2.0, 3.0, 4.0))")

// Expected output (not verified by execution):
// primes up to 30: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
// average: 2.5
