// Example.java - common String methods, immutability, StringBuilder, text blocks.

public class Example {
    public static void main(String[] args) {
        System.out.println("--- common methods ---");
        System.out.println("[" + "  hello  ".trim() + "]");
        System.out.println("hello".toUpperCase());
        System.out.println("hello world".contains("wor"));
        System.out.println(String.join("-", "a", "b", "c"));
        System.out.println("hello".replace("l", "L") + " (all occurrences replaced)");

        System.out.println("\n--- immutability: += creates a new string each time ---");
        String result = "";
        for (int i = 0; i < 5; i++) {
            result += i;
        }
        System.out.println("built via +=: " + result);

        System.out.println("\n--- StringBuilder for efficient repeated appends ---");
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            sb.append(i);
        }
        System.out.println("built via StringBuilder: " + sb.toString());

        System.out.println("\n--- text block ---");
        String json = """
            {
              "name": "Ada"
            }""";
        System.out.println(json);
    }
}
