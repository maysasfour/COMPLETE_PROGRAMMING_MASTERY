"""Solution 01 - Purify These Functions."""


def sell_pure(inventory, item, quantity):
    return {**inventory, item: inventory[item] - quantity}  # a NEW dict, original untouched


def add_discount_pure(prices):
    return [p * 0.9 for p in prices]  # a NEW list, original untouched


def main():
    original_inventory = {"widgets": 10}
    new_inventory = sell_pure(original_inventory, "widgets", 3)
    print(f"original_inventory (unchanged): {original_inventory}")
    print(f"new_inventory: {new_inventory}")

    original_prices = [10.0, 20.0, 30.0]
    discounted = add_discount_pure(original_prices)
    print(f"original_prices (unchanged): {original_prices}")
    print(f"discounted: {discounted}")


if __name__ == "__main__":
    main()
