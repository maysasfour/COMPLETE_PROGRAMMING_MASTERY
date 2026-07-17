"""Greedy Algorithms -- activity selection, fractional knapsack (contrasted
directly against Lesson 12's 0/1 knapsack), and a genuine demonstration of
greedy coin change FAILING on a non-canonical coin system, cross-checked
against Lesson 12's DP solution."""

import importlib.util
import os

# Same explicit-module-name technique established in Lesson 11's implementation.py,
# for the same reason: this file and Lesson 12's are both named `implementation.py`,
# and a plain sys.path + `from implementation import X` import collided the first
# time this was tried, exactly as documented in Lesson 11's own fix.
_dp_module_path = os.path.join(os.path.dirname(__file__), "..", "12-Dynamic-Programming", "implementation.py")
_spec = importlib.util.spec_from_file_location("dp_lesson_implementation", _dp_module_path)
_dp_module = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_dp_module)
coin_change_tabulated = _dp_module.coin_change_tabulated
knapsack_01 = _dp_module.knapsack_01


def activity_selection(activities):
    """activities: list of (start, end) tuples. Greedily picks the activity
    that finishes EARLIEST among those still compatible with what's already
    selected -- sorting by end time (not start time, and not duration) is
    the crucial, provably-correct greedy choice: whichever remaining
    activity frees up the room soonest leaves the most possible room for
    everything that comes after it."""
    sorted_activities = sorted(activities, key=lambda activity: activity[1])
    selected = []
    last_end = float("-inf")
    for start, end in sorted_activities:
        if start >= last_end:
            selected.append((start, end))
            last_end = end
    return selected


def fractional_knapsack(weights, values, capacity):
    """Unlike 0/1 knapsack (Lesson 12), items here CAN be split -- take any
    fraction of an item's weight for that same fraction of its value. This
    is exactly what makes greedy provably optimal here (and NOT for 0/1):
    sorting by value-per-weight ratio and always taking as much as possible
    of the best remaining ratio can never be improved on, because there's no
    "wasted" leftover capacity from being forced to skip a partial item."""
    items = sorted(zip(weights, values), key=lambda item: item[1] / item[0], reverse=True)
    remaining_capacity = capacity
    total_value = 0.0
    for weight, value in items:
        if remaining_capacity <= 0:
            break
        taken_weight = min(weight, remaining_capacity)
        fraction = taken_weight / weight
        total_value += fraction * value
        remaining_capacity -= taken_weight
    return total_value


def coin_change_greedy(coins, amount):
    """The greedy approach: always take the LARGEST coin that still fits,
    repeat. Fast (O(amount) at worst) and gives the OPTIMAL answer for
    "canonical" coin systems like standard currency (US coins: 1,5,10,25) --
    but is NOT guaranteed correct in general, demonstrated directly below."""
    remaining = amount
    count = 0
    for coin in sorted(coins, reverse=True):
        if remaining <= 0:
            break
        num_coins = remaining // coin
        count += num_coins
        remaining -= num_coins * coin
    return count if remaining == 0 else float("inf")


if __name__ == "__main__":
    print("=== Activity Selection ===")
    activities = [(1, 4), (3, 5), (0, 6), (5, 7), (3, 9), (5, 9), (6, 10), (8, 11), (8, 12), (2, 14), (12, 16)]
    selected = activity_selection(activities)
    print("activities (start, end):", activities)
    print("selected (max non-overlapping, greedy by earliest finish time):", selected)
    print("count selected:", len(selected))

    print("\n=== Fractional Knapsack vs. 0/1 Knapsack (Lesson 12) -- same items, different answers ===")
    weights = [2, 3, 4, 5]
    values = [3, 4, 5, 6]
    capacity = 5
    fractional_result = fractional_knapsack(weights, values, capacity)
    zero_one_result = knapsack_01(weights, values, capacity)
    print(f"weights={weights}, values={values}, capacity={capacity}")
    print("fractional knapsack (greedy, provably optimal here):", fractional_result)
    print("0/1 knapsack (DP, Lesson 12):", zero_one_result)
    print("Fractional >= 0/1, as expected (splitting items can only ever help, never hurt):",
          fractional_result >= zero_one_result)

    print("\n=== Coin Change: greedy works for a CANONICAL coin system ===")
    us_coins = [1, 5, 10, 25]
    for amount in [30, 41, 63]:
        greedy_result = coin_change_greedy(us_coins, amount)
        dp_result = coin_change_tabulated(us_coins, amount)
        print(f"amount={amount}, coins={us_coins}: greedy={greedy_result}, dp={dp_result}, match={greedy_result == dp_result}")

    print("\n=== Coin Change: greedy FAILS for a NON-canonical coin system -- a real, reproduced wrong answer ===")
    weird_coins = [1, 3, 4]
    for amount in [6]:
        greedy_result = coin_change_greedy(weird_coins, amount)
        dp_result = coin_change_tabulated(weird_coins, amount)
        print(f"amount={amount}, coins={weird_coins}: greedy={greedy_result}, dp={dp_result}, match={greedy_result == dp_result}")
        if greedy_result != dp_result:
            print(f"  Greedy picks the largest coin first (4), leaving 2, which needs two 1-coins: 4+1+1 = 3 coins.")
            print(f"  The DP-verified OPTIMAL answer uses 3+3 = 2 coins instead.")
            print(f"  Greedy's local 'take the biggest coin now' choice is provably WRONG here.")
