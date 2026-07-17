import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.HexFormat;

public class Example {

    static String md5(String password) throws NoSuchAlgorithmException {
        return HexFormat.of().formatHex(MessageDigest.getInstance("MD5").digest(password.getBytes()));
    }

    static byte[] randomSalt() {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    static String pbkdf2(String password, byte[] salt) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 120_000, 256);
        return HexFormat.of().formatHex(SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded());
    }

    static class UserAccount {
        final String username;
        byte[] salt;
        String passwordHash;

        UserAccount(String username, String password) throws Exception {
            this.username = username;
            this.salt = randomSalt();
            this.passwordHash = pbkdf2(password, salt);
        }

        boolean checkPassword(String candidate) throws Exception {
            return pbkdf2(candidate, salt).equals(passwordHash);
        }

        void changePassword(String oldPassword, String newPassword) throws Exception {
            if (!checkPassword(oldPassword)) {
                throw new SecurityException("Old password is incorrect -- password NOT changed");
            }
            this.salt = randomSalt(); // fresh salt for the new password too
            this.passwordHash = pbkdf2(newPassword, salt);
        }
    }

    public static void main(String[] args) throws Exception {
        System.out.println("=== Step 1: MD5's real information leak ===");
        String md5Alice = md5("Summer2024!");
        String md5Bob = md5("Summer2024!"); // Bob happens to pick the same password as Alice
        System.out.println("Alice's MD5 hash: " + md5Alice);
        System.out.println("Bob's MD5 hash:   " + md5Bob);
        System.out.println("Identical: " + md5Alice.equals(md5Bob) + "  <- BUG: same password reveals as same hash!");

        System.out.println("\n=== Step 2: PBKDF2 with per-user salt ===");
        UserAccount alice = new UserAccount("alice", "Summer2024!");
        UserAccount bob = new UserAccount("bob", "Summer2024!"); // same password again
        System.out.println("Alice's PBKDF2 hash: " + alice.passwordHash);
        System.out.println("Bob's PBKDF2 hash:   " + bob.passwordHash);
        System.out.println("Identical: " + alice.passwordHash.equals(bob.passwordHash) + "  <- correct: different salts, different hashes");

        System.out.println("\n=== Step 3 & 4: changePassword() genuinely re-verifies the old password ===");
        try {
            alice.changePassword("WrongOldPassword", "NewPass123!");
        } catch (SecurityException e) {
            System.out.println("Rejected: " + e.getMessage());
        }
        boolean stillOldPassword = alice.checkPassword("Summer2024!");
        System.out.println("Alice's password still the OLD one after the rejected attempt: " + stillOldPassword);

        alice.changePassword("Summer2024!", "NewPass123!");
        System.out.println("Password changed with the CORRECT old password.");
        System.out.println("New password verifies: " + alice.checkPassword("NewPass123!"));
        System.out.println("Old password no longer works: " + !alice.checkPassword("Summer2024!"));
    }
}
