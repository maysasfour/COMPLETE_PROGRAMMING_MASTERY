// Exercise: given a list of Product maps, use where/map/reduce to compute total
// in-stock price and a list of in-stock names.

var products = [
  {'name': 'Widget', 'price': 9.99, 'inStock': true},
  {'name': 'Gadget', 'price': 19.99, 'inStock': false},
  {'name': 'Gizmo', 'price': 14.99, 'inStock': true},
];

double totalInStockPrice(List<Map<String, Object>> products) {
  // TODO: where inStock, map to price, reduce with +
  return 0.0;
}

List<String> inStockNames(List<Map<String, Object>> products) {
  // TODO: where inStock, map to name
  return [];
}

void main() {
  print('total: ${totalInStockPrice(products)}'); // expected: 24.98
  print('names: ${inStockNames(products)}');        // expected: [Widget, Gizmo]
}
