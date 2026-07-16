package com.example.taskapi.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.List;

/**
 * Issues and validates JWTs (JSON Web Tokens). A JWT is a signed, self-contained
 * token: it carries its own claims (username, roles, expiry) and a signature the
 * server can verify WITHOUT needing to look anything up in a database or session
 * store -- this is what makes JWT-based auth genuinely STATELESS (Lesson 01's
 * fourth REST fundamental), unlike traditional session-cookie authentication,
 * which requires the server to remember each session server-side.
 */
@Service
public class JwtService {

    // NEVER hardcode a real signing key like this in production -- use an environment
    // variable or a secrets manager. Hardcoded here ONLY for a self-contained lesson.
    private final SecretKey key = Keys.hmacShaKeyFor(
            "this-is-a-demo-secret-key-at-least-32-bytes-long!".getBytes());

    private static final long EXPIRATION_MS = 1000 * 60 * 60; // 1 hour

    public String generateToken(String username, List<String> roles) {
        return Jwts.builder()
                .subject(username)
                .claim("roles", roles)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + EXPIRATION_MS))
                .signWith(key)
                .compact();
    }

    public Claims parseClaims(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public boolean isValid(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (Exception e) {
            return false; // expired, malformed, or signature doesn't match -- all treated as invalid
        }
    }
}
