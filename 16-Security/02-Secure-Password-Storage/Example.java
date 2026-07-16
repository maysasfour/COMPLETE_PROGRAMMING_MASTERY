// Example.java - Secure Password Storage: fast, unsalted hashing (MD5) is a real,
// measurable liability for password storage; a slow, salted key-derivation function
// (PBKDF2, built into the JDK's own javax.crypto) is the correct approach.
// Demonstrated with real, measured hash outputs and real, measured timing.

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.util.HexFormat;

public class Example {

    // ============================================================
    // VIOLATION: plain, unsalted MD5. Two users with the SAME password get the
    // EXACT SAME hash -- a real, observable vulnerability (identical hashes leak
    // that two accounts share a password, enabling rainbow-table lookups). MD5
    // is also extremely fast to compute, making brute-force attacks cheap.
    // ============================================================
    static String md5(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("MD5");
        return HexFormat.of().formatHex(digest.digest(password.getBytes()));
    }

    // ============================================================
    // FIX: PBKDF2 with a random, per-password SALT and a deliberately large
    // iteration count -- a REAL key-derivation function built into the JDK's
    // own javax.crypto, not a toy substitute.
    // ============================================================
    static byte[] generateSalt() {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    static String pbkdf2(String password, byte[] salt, int iterations) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] hash = factory.generateSecret(spec).getEncoded();
        return HexFormat.of().formatHex(hash);
    }

    public static void main(String[] args) throws Exception {
        System.out.println("=== Violation: plain MD5 -- identical passwords produce IDENTICAL hashes ===");
        String aliceHash = md5("Summer2024!");
        String bobHash = md5("Summer2024!"); // Bob happens to pick the SAME password as Alice
        System.out.println("  Alice's MD5 hash: " + aliceHash);
        System.out.println("  Bob's MD5 hash:   " + bobHash);
        System.out.println("  Hashes identical: " + aliceHash.equals(bobHash) +
                "  <- BUG: an attacker who cracks ONE of these instantly knows BOTH users' password!");

        System.out.println("\n=== Fixed: PBKDF2 with a random salt -- identical passwords produce DIFFERENT hashes ===");
        byte[] aliceSalt = generateSalt();
        byte[] bobSalt = generateSalt(); // a DIFFERENT random salt per user
        String aliceHashFixed = pbkdf2("Summer2024!", aliceSalt, 120_000);
        String bobHashFixed = pbkdf2("Summer2024!", bobSalt, 120_000);
        System.out.println("  Alice's PBKDF2 hash: " + aliceHashFixed);
        System.out.println("  Bob's PBKDF2 hash:   " + bobHashFixed);
        System.out.println("  Hashes identical: " + aliceHashFixed.equals(bobHashFixed) +
                "  <- correct: identical passwords now produce COMPLETELY different stored hashes");

        System.out.println("\n--- Confirming a correct password still verifies successfully against its OWN salt ---");
        String recomputed = pbkdf2("Summer2024!", aliceSalt, 120_000);
        System.out.println("  Recomputing Alice's hash with her OWN salt matches stored hash: " + recomputed.equals(aliceHashFixed));

        System.out.println("\n=== Measuring the REAL computational cost difference (brute-force resistance) ===");
        int md5Attempts = 100_000;
        long md5Start = System.nanoTime();
        for (int i = 0; i < md5Attempts; i++) { md5("guess" + i); }
        long md5Elapsed = (System.nanoTime() - md5Start) / 1_000_000;
        System.out.println("  " + md5Attempts + " MD5 hashes computed in " + md5Elapsed + " ms (" +
                String.format("%.5f", md5Elapsed / (double) md5Attempts) + " ms/hash -- CHEAP for an attacker to brute-force)");

        int pbkdf2Attempts = 20;
        long pbkdf2Start = System.nanoTime();
        byte[] fixedSalt = generateSalt();
        for (int i = 0; i < pbkdf2Attempts; i++) { pbkdf2("guess" + i, fixedSalt, 120_000); }
        long pbkdf2Elapsed = (System.nanoTime() - pbkdf2Start) / 1_000_000;
        double pbkdf2PerHash = pbkdf2Elapsed / (double) pbkdf2Attempts;
        System.out.println("  " + pbkdf2Attempts + " PBKDF2 hashes computed in " + pbkdf2Elapsed + " ms (" +
                String.format("%.2f", pbkdf2PerHash) + " ms/hash -- deliberately EXPENSIVE, making brute-forcing far costlier)");

        double md5PerHash = md5Elapsed / (double) md5Attempts;
        System.out.println("\n  PBKDF2 was " + String.format("%.0f", pbkdf2PerHash / md5PerHash) +
                "x slower per hash than MD5 -- exactly the deliberate cost that protects against brute-force attacks.");
    }
}
