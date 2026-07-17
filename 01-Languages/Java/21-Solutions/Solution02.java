import java.util.LinkedHashMap;
import java.util.Map;

public class Solution02 {

    static Map<String, Integer> wordFrequencies(String text) {
        Map<String, Integer> frequencies = new LinkedHashMap<>();
        String cleaned = text.toLowerCase().replaceAll("[.,!?]", "");
        for (String word : cleaned.split("\\s+")) {
            if (word.isEmpty()) continue;
            frequencies.merge(word, 1, Integer::sum);
        }
        return frequencies;
    }

    public static void main(String[] args) {
        System.out.println(wordFrequencies("The cat sat. The cat ran!"));
    }
}
