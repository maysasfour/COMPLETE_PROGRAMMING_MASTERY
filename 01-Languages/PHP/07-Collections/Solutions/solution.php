<?php
declare(strict_types=1);

$products = [
    ["name" => "Widget", "price" => 9.99, "inStock" => true],
    ["name" => "Gadget", "price" => 19.99, "inStock" => false],
    ["name" => "Gizmo", "price" => 14.99, "inStock" => true],
];

function totalInStockPrice(array $products): float {
    $inStock = array_filter($products, fn($p) => $p["inStock"]);
    $prices = array_map(fn($p) => $p["price"], $inStock);
    return array_sum($prices);
}

function inStockNames(array $products): array {
    $inStock = array_filter($products, fn($p) => $p["inStock"]);
    $names = array_map(fn($p) => $p["name"], $inStock);
    return array_values($names); // re-index, since array_filter preserved original keys
}

echo "total: " . totalInStockPrice($products) . "\n";
echo "names: " . implode(", ", inStockNames($products)) . "\n";
