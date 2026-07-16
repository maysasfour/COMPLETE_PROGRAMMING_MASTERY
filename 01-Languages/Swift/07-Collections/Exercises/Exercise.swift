// Exercise: given an array of Product structs, use filter/map/reduce to compute total
// in-stock price and a list of in-stock names. NOT COMPILED/RUN -- see course README.

struct Product {
    let name: String
    let price: Double
    let inStock: Bool
}

func totalInStockPrice(_ products: [Product]) -> Double {
    // TODO: filter to inStock, map to price, reduce with +
    return 0.0
}

func inStockNames(_ products: [Product]) -> [String] {
    // TODO: filter to inStock, map to name
    return []
}

let products = [
    Product(name: "Widget", price: 9.99, inStock: true),
    Product(name: "Gadget", price: 19.99, inStock: false),
    Product(name: "Gizmo", price: 14.99, inStock: true),
]
print("total: \(totalInStockPrice(products))") // expected: 24.98
print("names: \(inStockNames(products))")        // expected: ["Widget", "Gizmo"]
