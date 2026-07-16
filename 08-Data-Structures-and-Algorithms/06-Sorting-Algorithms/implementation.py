"""
Lesson 06 - Sorting Algorithms
Implements bubble, selection, insertion, merge, and quick sort, each
instrumented to count comparisons and swaps/writes so the README's
dry-run explanation can quote real, executed numbers rather than a
generic textbook trace.

Run with:
    python implementation.py
"""


def bubble_sort(items):
    """Repeatedly walks the list, swapping adjacent out-of-order pairs.

    Each full pass "bubbles" the largest remaining unsorted value to its
    correct final position at the end, which is why the inner loop
    shrinks by one each pass - the last `pass_number` elements are
    already guaranteed sorted and never need re-checking.

    Returns (sorted_list, comparisons, swaps) - the counts exist purely
    to make the algorithm's behavior measurable for the README, not
    because production sorting code would track this.
    """
    arr = items.copy()
    n = len(arr)
    comparisons = 0
    swaps = 0

    for pass_number in range(n - 1):
        swapped_this_pass = False
        for i in range(n - 1 - pass_number):
            comparisons += 1
            if arr[i] > arr[i + 1]:
                arr[i], arr[i + 1] = arr[i + 1], arr[i]
                swaps += 1
                swapped_this_pass = True
        if not swapped_this_pass:
            # No swap happened in a full pass, meaning the list is
            # already sorted - stopping early is what gives bubble sort
            # its best-case O(n) on already-sorted input.
            break

    return arr, comparisons, swaps


def selection_sort(items):
    """Repeatedly finds the minimum of the unsorted remainder and swaps
    it into place at the front of that remainder.

    Unlike bubble sort, selection sort does AT MOST ONE swap per pass
    (only after the minimum is found), no matter how unsorted the
    remainder is - the cost of "finding the minimum" is paid in
    comparisons, not swaps.
    """
    arr = items.copy()
    n = len(arr)
    comparisons = 0
    swaps = 0

    for i in range(n - 1):
        min_index = i
        for j in range(i + 1, n):
            comparisons += 1
            if arr[j] < arr[min_index]:
                min_index = j
        if min_index != i:
            arr[i], arr[min_index] = arr[min_index], arr[i]
            swaps += 1

    return arr, comparisons, swaps


def insertion_sort(items):
    """Builds a sorted prefix one element at a time, shifting larger
    already-sorted elements right to make room for each new element.

    This is the algorithm most similar to how a person sorts a hand of
    playing cards: pick up the next card, slide it left past every
    card bigger than it, drop it in the gap.
    """
    arr = items.copy()
    n = len(arr)
    comparisons = 0
    shifts = 0

    for i in range(1, n):
        key = arr[i]
        j = i - 1
        while j >= 0:
            comparisons += 1
            if arr[j] > key:
                arr[j + 1] = arr[j]
                shifts += 1
                j -= 1
            else:
                break
        arr[j + 1] = key

    return arr, comparisons, shifts


def merge_sort(items):
    """Recursively splits the list in half until each piece has 0 or 1
    elements (trivially sorted), then merges sorted halves back together.

    Unlike the three algorithms above, merge sort does not sort in
    place - merging two sorted halves into one sorted whole requires a
    temporary list to hold the result while both halves are still being
    read from, which is exactly why merge sort's space complexity is
    O(n) rather than O(1).

    Returns (sorted_list, comparisons, merge_operations) - merge_operations
    counts how many times the merge step runs, one per recursive
    combine step, to make the divide-and-conquer structure countable.
    """
    comparisons = [0]
    merge_ops = [0]

    def _merge_sort(sub):
        if len(sub) <= 1:
            return sub
        mid = len(sub) // 2
        left = _merge_sort(sub[:mid])
        right = _merge_sort(sub[mid:])
        return _merge(left, right)

    def _merge(left, right):
        merge_ops[0] += 1
        result = []
        i = j = 0
        while i < len(left) and j < len(right):
            comparisons[0] += 1
            if left[i] <= right[j]:
                result.append(left[i])
                i += 1
            else:
                result.append(right[j])
                j += 1
        # One side is exhausted - the remainder of the other side is
        # already sorted, so it can be appended wholesale with no
        # further comparisons needed.
        result.extend(left[i:])
        result.extend(right[j:])
        return result

    sorted_arr = _merge_sort(items.copy())
    return sorted_arr, comparisons[0], merge_ops[0]


def quick_sort(items):
    """Picks a pivot, partitions the list into elements smaller and
    larger than the pivot, then recursively sorts each partition.

    This implementation always picks the LAST element of each
    (sub)list as the pivot - a simple, deterministic choice that keeps
    the partition step easy to follow, at the cost of degrading to
    O(n^2) on already-sorted input (see the README's Advanced section
    for why).
    """
    comparisons = [0]
    swaps = [0]

    def _quick_sort(arr, low, high):
        if low < high:
            pivot_index = _partition(arr, low, high)
            _quick_sort(arr, low, pivot_index - 1)
            _quick_sort(arr, pivot_index + 1, high)

    def _partition(arr, low, high):
        pivot = arr[high]
        i = low - 1  # boundary of the "smaller than pivot" region
        for j in range(low, high):
            comparisons[0] += 1
            if arr[j] <= pivot:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
                swaps[0] += 1
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        swaps[0] += 1
        return i + 1

    arr = items.copy()
    _quick_sort(arr, 0, len(arr) - 1)
    return arr, comparisons[0], swaps[0]


def main():
    data = [5, 2, 9, 1, 5, 6]

    print(f"Original data: {data}")

    result, comparisons, swaps = bubble_sort(data)
    print(f"\n--- bubble_sort({data}) ---")
    print(f"Sorted: {result}, comparisons: {comparisons}, swaps: {swaps}")

    result, comparisons, swaps = selection_sort(data)
    print(f"\n--- selection_sort({data}) ---")
    print(f"Sorted: {result}, comparisons: {comparisons}, swaps: {swaps}")

    result, comparisons, shifts = insertion_sort(data)
    print(f"\n--- insertion_sort({data}) ---")
    print(f"Sorted: {result}, comparisons: {comparisons}, shifts: {shifts}")

    result, comparisons, merge_ops = merge_sort(data)
    print(f"\n--- merge_sort({data}) ---")
    print(f"Sorted: {result}, comparisons: {comparisons}, merge_operations: {merge_ops}")

    result, comparisons, swaps = quick_sort(data)
    print(f"\n--- quick_sort({data}) ---")
    print(f"Sorted: {result}, comparisons: {comparisons}, swaps: {swaps}")

    print("\n--- Already-sorted input, bubble_sort best case ---")
    sorted_input = [1, 2, 3, 4, 5]
    result, comparisons, swaps = bubble_sort(sorted_input)
    print(f"bubble_sort({sorted_input}) -> comparisons: {comparisons}, swaps: {swaps} (early exit, no swaps needed)")

    print("\n--- Already-sorted input, quick_sort worst case ---")
    result, comparisons, swaps = quick_sort(sorted_input)
    print(f"quick_sort({sorted_input}) -> comparisons: {comparisons}, swaps: {swaps} (last-element pivot degrades on sorted input)")


if __name__ == "__main__":
    main()
