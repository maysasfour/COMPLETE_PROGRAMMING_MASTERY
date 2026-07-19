products <- data.frame(
  name = c("Widget", "Gadget", "Gizmo", "Thingamajig"),
  price = c(9.99, 24.99, 14.50, 5.00),
  qty = c(3, 2, 5, 20)
)
products$total <- products$price * products$qty
print(products)

cat("\n--- rows where total > 50 ---\n")
print(products[products$total > 50, ])
