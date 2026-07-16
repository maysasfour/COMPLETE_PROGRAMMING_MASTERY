package com.example.taskapi.security;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * A minimal login endpoint backed by a HARDCODED in-memory user store -- deliberately
 * simple for a self-contained lesson. A real application would look up users (and
 * their HASHED passwords) in a database instead, via a proper UserDetailsService.
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;

    // username -> (bcrypt-hashed password, roles)
    private final Map<String, UserRecord> users;

    public AuthController(JwtService jwtService, PasswordEncoder passwordEncoder) {
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
        this.users = Map.of(
                "alice", new UserRecord(passwordEncoder.encode("alice123"), List.of("USER")),
                "admin", new UserRecord(passwordEncoder.encode("admin123"), List.of("USER", "ADMIN"))
        );
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginRequest request) {
        UserRecord user = users.get(request.username());
        if (user == null || !passwordEncoder.matches(request.password(), user.passwordHash())) {
            return ResponseEntity.status(401).build(); // 401 Unauthorized -- bad credentials
        }
        String token = jwtService.generateToken(request.username(), user.roles());
        return ResponseEntity.ok(Map.of("token", token));
    }

    private record UserRecord(String passwordHash, List<String> roles) {}
}
