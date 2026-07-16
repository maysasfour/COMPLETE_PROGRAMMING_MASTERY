// Exercise: given a list of Product data classes, use filter/map/sumOf to compute the
// total price of in-stock products, and a re-usable list of just the names of in-stock products.

data class Product(val name: String, val price: Double, val inStock: Boolean)

fun totalInStockPrice(products: List<Product>): Double {
    // TODO: filter to inStock, map/sumOf price
    return 0.0
}

fun inStockNames(products: List<Product>): List<String> {
    // TODO: filter to inStock, map to name
    return emptyList()
}

fun main() {
    val products = listOf(
        Product("Widget", 9.99, true),
        Product("Gadget", 19.99, false),
        Product("Gizmo", 14.99, true),
    )
    println("total: ${totalInStockPrice(products)}") // expected: 24.98
    println("names: ${inStockNames(products)}")        // expected: [Widget, Gizmo]
}
