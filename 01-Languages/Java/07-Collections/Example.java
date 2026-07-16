// Example.java - List/Map/Set and the Stream API.

import java.util.*;
import java.util.stream.Collectors;

public class Example {
    public static void main(String[] args) {
        System.out.println("--- List, Map, Set ---");
        List<Integer> scores = new ArrayList<>();
        scores.add(95);
        scores.add(88);
        System.out.println("scores: " + scores);

        Map<String, Integer> ages = new HashMap<>();
        ages.put("Ada", 30);
        System.out.println("ages.get(\"Ada\"): " + ages.get("Ada"));
        System.out.println("ages.getOrDefault(\"Unknown\", -1): " + ages.getOrDefault("Unknown", -1));

        Set<String> uniqueTags = new HashSet<>(List.of("js", "css", "js"));
        System.out.println("uniqueTags (duplicates removed): " + uniqueTags.size() + " items");

        System.out.println("\n--- Stream API ---");
        List<Integer> numbers = List.of(1, 2, 3, 4, 5);

        List<Integer> doubled = numbers.stream().map(n -> n * 2).collect(Collectors.toList());
        List<Integer> evens = numbers.stream().filter(n -> n % 2 == 0).collect(Collectors.toList());
        int total = numbers.stream().mapToInt(Integer::intValue).sum();
        boolean hasEven = numbers.stream().anyMatch(n -> n % 2 == 0);
        boolean allPositive = numbers.stream().allMatch(n -> n > 0);

        System.out.println("doubled: " + doubled);
        System.out.println("evens: " + evens);
        System.out.println("total: " + total);
        System.out.println("hasEven: " + hasEven);
        System.out.println("allPositive: " + allPositive);
        System.out.println("original numbers unchanged: " + numbers);
    }
}
