data class Product(val name: String, val price: Double, val inStock: Boolean)

fun totalInStockPrice(products: List<Product>): Double =
    products.filter { it.inStock }.sumOf { it.price }

fun inStockNames(products: List<Product>): List<String> =
    products.filter { it.inStock }.map { it.name }

fun main() {
    val products = listOf(
        Product("Widget", 9.99, true),
        Product("Gadget", 19.99, false),
        Product("Gizmo", 14.99, true),
    )
    println("total: ${totalInStockPrice(products)}")
    println("names: ${inStockNames(products)}")
}
