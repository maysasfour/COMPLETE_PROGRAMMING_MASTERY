<?php
declare(strict_types=1);
// Exercise: given a list of associative arrays representing products, use array_filter,
// array_map, and array_sum to compute the total price of all in-stock products, and
// return a re-indexed (array_values) list of just the names of in-stock products.

$products = [
    ["name" => "Widget", "price" => 9.99, "inStock" => true],
    ["name" => "Gadget", "price" => 19.99, "inStock" => false],
    ["name" => "Gizmo", "price" => 14.99, "inStock" => true],
];

function totalInStockPrice(array $products): float {
    // TODO: filter to inStock === true, map to "price", sum the result
    return 0.0;
}

function inStockNames(array $products): array {
    // TODO: filter to inStock === true, map to "name", re-index with array_values
    return [];
}

echo "total: " . totalInStockPrice($products) . "\n"; // expected: 24.98
echo "names: " . implode(", ", inStockNames($products)) . "\n"; // expected: Widget, Gizmo
