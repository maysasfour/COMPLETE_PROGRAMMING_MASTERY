// solution-01.ts - typed inventory using Record<Category, Product[]> and readonly fields.

interface Product {
  readonly sku: string;
  name: string;
  price: number;
}

type Category = "electronics" | "groceries" | "clothing";

const inventory: Record<Category, Product[]> = {
  electronics: [
    { sku: "E-1", name: "Headphones", price: 59.99 },
    { sku: "E-2", name: "Charger", price: 19.99 },
  ],
  groceries: [
    { sku: "G-1", name: "Coffee", price: 8.5 },
  ],
  clothing: [
    { sku: "C-1", name: "T-Shirt", price: 15 },
    { sku: "C-2", name: "Jeans", price: 45 },
  ],
};

function totalValue(products: Product[]): number {
  return products.reduce((sum, p) => sum + p.price, 0);
}

function totalInventoryValue(inv: Record<Category, Product[]>): number {
  return Object.values(inv).reduce((sum, products) => sum + totalValue(products), 0);
}

console.log("electronics total:", totalValue(inventory.electronics));
console.log("groceries total:", totalValue(inventory.groceries));
console.log("clothing total:", totalValue(inventory.clothing));
console.log("grand total:", totalInventoryValue(inventory));

const expectedGrandTotal = 59.99 + 19.99 + 8.5 + 15 + 45;
console.log("hand-summed expected total:", expectedGrandTotal);
console.log("match:", Math.abs(totalInventoryValue(inventory) - expectedGrandTotal) < 0.001);
