var products = [
  {'name': 'Widget', 'price': 9.99, 'inStock': true},
  {'name': 'Gadget', 'price': 19.99, 'inStock': false},
  {'name': 'Gizmo', 'price': 14.99, 'inStock': true},
];

double totalInStockPrice(List<Map<String, Object>> products) {
  return products
      .where((p) => p['inStock'] as bool)
      .map((p) => p['price'] as double)
      .reduce((a, b) => a + b);
}

List<String> inStockNames(List<Map<String, Object>> products) {
  return products
      .where((p) => p['inStock'] as bool)
      .map((p) => p['name'] as String)
      .toList();
}

void main() {
  print('total: ${totalInStockPrice(products)}');
  print('names: ${inStockNames(products)}');
}
