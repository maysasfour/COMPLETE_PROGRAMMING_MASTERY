import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class Solution04 {

    // Explicit loop with a HashSet purely for O(1) "have I seen this?" lookups --
    // the ORDER guarantee comes from building the result list ourselves in
    // encounter order, not from the HashSet (which has no ordering guarantee at all).
    static <T> List<T> dedupeLoop(List<T> items) {
        Set<T> seen = new HashSet<>();
        List<T> result = new ArrayList<>();
        for (T item : items) {
            if (seen.add(item)) {
                result.add(item);
            }
        }
        return result;
    }

    // LinkedHashSet preserves insertion order NATIVELY -- adding an item already
    // present is a no-op that does not move its position, so converting straight
    // back to a list gives first-seen order with no extra bookkeeping.
    static <T> List<T> dedupeLinkedHashSet(List<T> items) {
        return new ArrayList<>(new LinkedHashSet<>(items));
    }

    public static void main(String[] args) {
        List<Integer> items = List.of(3, 1, 2, 3, 1, 4);
        List<Integer> loopResult = dedupeLoop(items);
        List<Integer> setResult = dedupeLinkedHashSet(items);

        System.out.println("Loop version:        " + loopResult);
        System.out.println("LinkedHashSet version: " + setResult);
        System.out.println("Both match: " + loopResult.equals(setResult));
    }
}
