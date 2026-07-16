// NOT COMPILED/RUN -- see course README for the disclosed reason.

struct Product {
    let name: String
    let price: Double
    let inStock: Bool
}

func totalInStockPrice(_ products: [Product]) -> Double {
    return products.filter { $0.inStock }.map { $0.price }.reduce(0, +)
}

func inStockNames(_ products: [Product]) -> [String] {
    return products.filter { $0.inStock }.map { $0.name }
}

let products = [
    Product(name: "Widget", price: 9.99, inStock: true),
    Product(name: "Gadget", price: 19.99, inStock: false),
    Product(name: "Gizmo", price: 14.99, inStock: true),
]
print("total: \(totalInStockPrice(products))")
print("names: \(inStockNames(products))")

// Expected output (not verified by execution):
// total: 24.98
// names: ["Widget", "Gizmo"]
