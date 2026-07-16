// Example.java - Authentication vs. Authorization, OAuth2-style scopes. A token can
// be genuinely, cryptographically VALID (correctly signed, not expired, not forged)
// while still not being ALLOWED to perform a specific operation -- that's what scopes
// enforce. Demonstrated with a real, working HMAC-signed token (via the JDK's own
// javax.crypto, not a toy stand-in) and a real bug caused by checking validity but
// not scope.

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class Example {

    static final String SECRET = "super-secret-signing-key-do-not-hardcode-in-real-code";

    // A genuinely working, HMAC-SHA256-signed token: "subject|scope|signature",
    // base64url-encoded. This is a real cryptographic signature via the JDK's
    // own javax.crypto -- not a mocked or simplified stand-in.
    static String issueToken(String subject, String scope) throws Exception {
        String payload = subject + "|" + scope;
        String signature = sign(payload);
        return Base64.getUrlEncoder().withoutPadding().encodeToString((payload + "|" + signature).getBytes(StandardCharsets.UTF_8));
    }

    static String sign(String payload) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        return Base64.getUrlEncoder().withoutPadding().encodeToString(mac.doFinal(payload.getBytes(StandardCharsets.UTF_8)));
    }

    record Claims(String subject, String scope) {}

    // Verifies the token is genuinely, cryptographically valid (correctly signed,
    // not tampered with) and returns its claims. This says NOTHING about what the
    // token's holder is actually ALLOWED to do -- that's a separate question.
    static Claims verifyToken(String token) throws Exception {
        String decoded = new String(Base64.getUrlDecoder().decode(token), StandardCharsets.UTF_8);
        String[] parts = decoded.split("\\|");
        String subject = parts[0], scope = parts[1], signature = parts[2];
        String expectedSignature = sign(subject + "|" + scope);
        if (!expectedSignature.equals(signature)) {
            throw new SecurityException("Invalid token signature");
        }
        return new Claims(subject, scope);
    }

    // ============================================================
    // VIOLATION: the delete endpoint checks that the token is VALID (properly
    // signed) but never checks its SCOPE. A read-only token is wrongly accepted
    // for a destructive write operation.
    // ============================================================
    static String deleteRecordViolation(String token) throws Exception {
        Claims claims = verifyToken(token); // only checks: is this signature genuine?
        return "Deleted record on behalf of " + claims.subject() + " (scope was: " + claims.scope() + ")";
        // BUG: never checked whether claims.scope() actually permits deletion!
    }

    // ============================================================
    // FIX: the delete endpoint ALSO checks that the token's scope actually
    // grants write access, rejecting genuinely valid tokens that simply
    // aren't ALLOWED to perform this specific operation.
    // ============================================================
    static String deleteRecordFixed(String token) throws Exception {
        Claims claims = verifyToken(token); // step 1: authentication -- is this token genuine?
        if (!claims.scope().contains("write")) { // step 2: authorization -- is this token ALLOWED to do this?
            throw new SecurityException("Token for " + claims.subject() + " has scope \"" + claims.scope() +
                    "\" -- write access required, request denied");
        }
        return "Deleted record on behalf of " + claims.subject() + " (scope was: " + claims.scope() + ")";
    }

    public static void main(String[] args) throws Exception {
        String readOnlyToken = issueToken("alice", "read");
        String readWriteToken = issueToken("bob", "read write");

        System.out.println("=== Violation: a genuinely valid token is accepted regardless of its scope ===");
        System.out.println("A READ-ONLY token (issued to alice, scope=\"read\") is used to call DELETE:");
        String result = deleteRecordViolation(readOnlyToken);
        System.out.println("  " + result + "  <- BUG: a read-only token was allowed to perform a DESTRUCTIVE write operation!");

        System.out.println("\n=== Fixed: the endpoint checks BOTH validity AND scope ===");
        System.out.println("The SAME read-only token is rejected for DELETE:");
        try {
            deleteRecordFixed(readOnlyToken);
            System.out.println("  (should not reach here)");
        } catch (SecurityException e) {
            System.out.println("  Rejected: " + e.getMessage());
        }

        System.out.println("A token WITH write scope (issued to bob, scope=\"read write\") is correctly accepted:");
        System.out.println("  " + deleteRecordFixed(readWriteToken));

        System.out.println("\n=== A tampered token is correctly rejected regardless of scope ===");
        String tamperedToken = readOnlyToken.substring(0, readOnlyToken.length() - 2) + "xx"; // corrupt the signature
        try {
            verifyToken(tamperedToken);
            System.out.println("  (should not reach here)");
        } catch (SecurityException e) {
            System.out.println("  Rejected: " + e.getMessage() + "  <- correct: a genuinely tampered token is caught by signature verification");
        }
    }
}
