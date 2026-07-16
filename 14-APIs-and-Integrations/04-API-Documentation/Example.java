// Example.java - API Documentation (OpenAPI/Swagger): documenting an API's contract
// (required fields, types) has real practical value beyond human-readable docs --
// it can be used to VALIDATE requests against that contract before they ever reach
// business logic. Demonstrated with a real crash caused by skipping that validation,
// then a fix.

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Example {

    // A minimal, hand-written OpenAPI-style contract for "create a user":
    // required fields "name" and "email". A real OpenAPI spec would express this
    // as YAML/JSON; this is the same idea, kept small enough to be self-contained.
    static class CreateUserSpec {
        static final Set<String> REQUIRED_FIELDS = Set.of("name", "email");
    }

    // ============================================================
    // VIOLATION: the endpoint's business logic uses request fields directly,
    // with NO validation against the documented contract. A request missing a
    // required field crashes deep inside business logic, with a confusing error,
    // instead of being rejected cleanly at the boundary.
    // ============================================================
    static String createUserViolation(Map<String, String> request) {
        String name = request.get("name");
        String email = request.get("email");
        return "Welcome email queued for " + name + " <" + email.toLowerCase() + ">"; // NPE if email is missing!
    }

    // ============================================================
    // FIX: validate the request against the documented contract FIRST. A
    // missing required field is rejected with a clear, specific error, before
    // business logic ever runs.
    // ============================================================
    static Set<String> findMissingFields(Map<String, String> request, Set<String> requiredFields) {
        Set<String> missing = new HashSet<>();
        for (String field : requiredFields) {
            if (!request.containsKey(field) || request.get(field) == null) {
                missing.add(field);
            }
        }
        return missing;
    }

    static String createUserFixed(Map<String, String> request) {
        Set<String> missing = findMissingFields(request, CreateUserSpec.REQUIRED_FIELDS);
        if (!missing.isEmpty()) {
            throw new IllegalArgumentException("Request does not match documented contract -- missing required field(s): " + missing);
        }
        String name = request.get("name");
        String email = request.get("email");
        return "Welcome email queued for " + name + " <" + email.toLowerCase() + ">";
    }

    public static void main(String[] args) {
        Map<String, String> incompleteRequest = new HashMap<>();
        incompleteRequest.put("name", "Ada Lovelace"); // "email" is missing entirely

        Map<String, String> validRequest = new HashMap<>();
        validRequest.put("name", "Grace Hopper");
        validRequest.put("email", "Grace.Hopper@Example.com");

        System.out.println("=== Violation: no validation against the documented contract ===");
        System.out.println("A request missing the REQUIRED \"email\" field is passed straight to business logic:");
        try {
            createUserViolation(incompleteRequest);
            System.out.println("  (should not reach here)");
        } catch (NullPointerException e) {
            System.out.println("  Crashed with: " + e.getClass().getSimpleName() +
                    "  <- BUG: a confusing internal crash, not a clean, documented API error!");
        }

        System.out.println("\n=== Fixed: the request is validated against the contract BEFORE business logic runs ===");
        System.out.println("The SAME incomplete request is now rejected cleanly:");
        try {
            createUserFixed(incompleteRequest);
            System.out.println("  (should not reach here)");
        } catch (IllegalArgumentException e) {
            System.out.println("  Rejected: " + e.getMessage() + "  <- correct: a clear, specific, documented error");
        }

        System.out.println("A request satisfying the full contract succeeds:");
        System.out.println("  " + createUserFixed(validRequest));
    }
}
