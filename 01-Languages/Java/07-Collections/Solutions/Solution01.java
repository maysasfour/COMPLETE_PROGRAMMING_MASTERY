// Solution01.java - word frequency counting and ranking, entirely via Stream pipelines.

import java.util.*;
import java.util.stream.Collectors;

public class Solution01 {
    static Map<String, Long> wordFrequency(String text) {
        String cleaned = text.toLowerCase().replaceAll("[.,!?]", "");
        return Arrays.stream(cleaned.split("\\s+"))
            .collect(Collectors.groupingBy(w -> w, Collectors.counting()));
    }

    static List<Map.Entry<String, Long>> topN(Map<String, Long> freq, int n) {
        return freq.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed()
                .thenComparing(Map.Entry.comparingByKey()))
            .limit(n)
            .collect(Collectors.toList());
    }

    public static void main(String[] args) {
        Map<String, Long> freq = wordFrequency("Cats, cats, and dogs. Dogs love cats!");
        for (Map.Entry<String, Long> entry : topN(freq, 2)) {
            System.out.println(entry.getKey() + "=" + entry.getValue());
        }
    }
}
