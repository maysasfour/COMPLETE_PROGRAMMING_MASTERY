# 04 — Authentication and Authorization

[Back to module overview](../README.md) | [Previous: Data Persistence with Spring Data JPA](../03-Data-Persistence-with-Spring-Data-JPA/README.md)

## Beginner: Two Genuinely Different Concerns

**Authentication** answers "who are you?" — proving identity, typically via a username/password exchanged for a token. **Authorization** answers "are you allowed to do *this specific thing*?" — a separate check that happens *after* authentication succeeds. This lesson secures the task API from Lessons 02–03 with both: a JWT-based login (authentication) and a role check restricting deletion to admins (authorization) — and verifies live that being logged in is *not* the same as being allowed to do everything.

## Beginner: JWTs Are Stateless, by Design

```java
public String generateToken(String username, List<String> roles) {
    return Jwts.builder()
            .subject(username)
            .claim("roles", roles)
            .expiration(new Date(System.currentTimeMillis() + EXPIRATION_MS))
            .signWith(key)
            .compact();
}
```

A JWT (JSON Web Token) carries its own claims (who, what roles, when it expires) and a cryptographic signature — the server can verify it's genuine and extract the user's identity/roles **with no database or session-store lookup at all**. This is directly what Lesson 01 called out as REST's fourth fundamental (statelessness): the server remembers nothing about "who's logged in" between requests; every request carries its own proof.

## Intermediate: Verifying a Token on Every Request

```java
@Component
public class JwtAuthFilter extends OncePerRequestFilter {
    protected void doFilterInternal(HttpServletRequest request, ...) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            // ...verify the token's signature, extract username + roles, and
            // populate Spring Security's context -- all from the token ITSELF
        }
        filterChain.doFilter(request, response);
    }
}
```

`JwtAuthFilter` runs once per request, before it reaches any controller. If the `Authorization: Bearer <token>` header carries a valid, unexpired, correctly-signed token, the filter populates Spring Security's context with the user's identity and roles — extracted entirely from the token's own claims.

## Intermediate: A Genuine, Verified Finding — Unauthenticated Requests Return 403, Not 401

Verified live: a `GET /tasks` request with **no** `Authorization` header returned **`403 Forbidden`**, not the `401 Unauthorized` one might expect. This is Spring Security's actual, documented default behavior in a stateless setup with no configured `AuthenticationEntryPoint`: without one, an anonymous (unauthenticated) request denied access simply gets `403`, since there's no `WWW-Authenticate` challenge configured to justify a `401`. A production API wanting a strict `401`-for-unauthenticated / `403`-for-wrong-role distinction would need to configure a custom `AuthenticationEntryPoint` explicitly — this lesson's default behavior is documented here exactly as observed, not as commonly assumed.

## Advanced: Role-Based Authorization with `@PreAuthorize`

```java
@DeleteMapping("/{id}")
@PreAuthorize("hasRole('ADMIN')")
public ResponseEntity<Void> deleteTask(@PathVariable Long id) { /* ... */ }
```

Verified live, in one continuous flow against a running instance:

```
GET  /tasks (no token)                     -> 403 (unauthenticated)
POST /auth/login {alice, wrong password}     -> 401 (bad credentials)
POST /auth/login {alice, correct password}    -> 200, {"token": "..."}
GET  /tasks (alice's token)                     -> 200, [] (authenticated as USER succeeds)
POST /tasks (alice's token, valid body)          -> 201 (USER can create)
DELETE /tasks/1 (alice's token)                    -> 403 (USER lacks ADMIN role!)
POST /auth/login {admin, correct password}          -> 200, {"token": "..."}
DELETE /tasks/1 (admin's token)                        -> 204 (ADMIN role succeeds)
```

This directly proves authentication and authorization are separate layers: alice successfully authenticated (her token worked for `GET`/`POST`) but was correctly denied a specific, role-gated action (`DELETE`) — while admin's token, carrying the `ADMIN` role, succeeded at the exact same operation.

## Detailed Example

See [pom.xml](pom.xml) (adds `spring-boot-starter-security` and the `jjwt` JWT library), [security/JwtService.java](src/main/java/com/example/taskapi/security/JwtService.java) (token generation/validation), [security/JwtAuthFilter.java](src/main/java/com/example/taskapi/security/JwtAuthFilter.java) (per-request token verification), [security/AuthController.java](src/main/java/com/example/taskapi/security/AuthController.java) (the `/auth/login` endpoint, backed by a hardcoded, BCrypt-hashed in-memory user store), [security/SecurityConfig.java](src/main/java/com/example/taskapi/security/SecurityConfig.java) (wires everything together, stateless session policy, per-path access rules), and [TaskController.java](src/main/java/com/example/taskapi/TaskController.java) (`@PreAuthorize("hasRole('ADMIN')")` on delete).

## Run It

```bash
cd 04-Backend-Development/04-Authentication-and-Authorization
mvn spring-boot:run
# in another terminal:
curl -X POST -H "Content-Type: application/json" -d '{"username":"alice","password":"alice123"}' http://localhost:8092/auth/login
# copy the returned token, then:
curl -H "Authorization: Bearer <token>" http://localhost:8092/tasks
```

Demo users: `alice`/`alice123` (role `USER`) and `admin`/`admin123` (roles `USER`, `ADMIN`).

## Expected Output

Running the verification sequence above prints exactly the status codes documented in the Advanced section — all confirmed against a real, running, JWT-secured Spring Boot application in this lesson's own verification.

## Common Mistakes

- Assuming an unauthenticated request always returns `401` — verified live that Spring Security's default (with no custom `AuthenticationEntryPoint`) returns `403` instead; don't hardcode this assumption into client error-handling without checking your actual security configuration.
- Storing plaintext passwords — this lesson uses `BCryptPasswordEncoder` to hash passwords before comparison, even in its deliberately-simplified hardcoded user store; never compare a submitted password directly against a stored plaintext value.
- Confusing "authenticated" with "authorized to do X" — verified live: alice's valid token proved her identity (authentication succeeded, `GET`/`POST` worked), but she was still correctly denied `DELETE` (authorization failed) because she lacked the `ADMIN` role.
- Hardcoding a real JWT signing secret in source code (done here *only* for a self-contained lesson) — a production application must load this from an environment variable or a secrets manager, never commit it to source control.

## Best Practices

- Keep authentication (proving identity) and authorization (checking permissions for a specific action) as clearly separate concerns — `SecurityConfig`'s per-path rules handle the former; `@PreAuthorize` on individual methods handles the latter.
- Use `SessionCreationPolicy.STATELESS` for token-based APIs — there's no server-side session to create or manage at all, consistent with REST's statelessness principle (Lesson 01).
- Always hash passwords (BCrypt or a similarly vetted algorithm) before storing or comparing them — never plaintext.

## Real-World Usage

JWT-based stateless authentication combined with Spring Security's role-based `@PreAuthorize` is a standard, widely-used pattern for securing production Java REST APIs and microservices — real systems typically add refresh tokens, token revocation/blacklisting, and a database-backed user store (rather than this lesson's hardcoded map) on top of the same fundamental mechanism demonstrated here.

## Summary

- Authentication (who are you?) and authorization (are you allowed to do this?) are distinct concerns, verified live to behave independently — a valid, authenticated token can still be correctly denied a specific, role-gated action.
- JWTs are genuinely stateless — the server verifies and extracts identity/roles from the token itself, with no database or session lookup, directly fulfilling REST's statelessness principle from Lesson 01.
- Spring Security's default unauthenticated-request response is `403`, not `401`, verified live — a real, specific behavior worth confirming in your own configuration rather than assuming.

## Key Terms

- **Authentication** — proving identity (who you are).
- **Authorization** — determining whether an authenticated identity is permitted to perform a specific action.
- **JWT (JSON Web Token)** — a signed, self-contained token carrying claims (identity, roles, expiry) verifiable without server-side session state.
- **`@PreAuthorize`** — a Spring Security annotation enforcing a role/permission check before a method executes.

## Interview Questions

1. **What's the difference between authentication and authorization, and how was this distinction proven (not just described) in this lesson?**
   Authentication establishes *who* a user is (verified via login, producing a JWT); authorization determines *what* that already-authenticated user is allowed to do. This was proven live, not just asserted: alice's valid, correctly-authenticated JWT worked for `GET`/`POST /tasks` (authentication succeeded), but the exact same valid token was rejected with `403` on `DELETE /tasks/{id}` (authorization failed, since alice's token only carried the `USER` role, not `ADMIN`) — while admin's token, carrying both roles, succeeded at that same `DELETE` call. This directly demonstrates the two checks are independent: passing one doesn't guarantee passing the other.

2. **Why is JWT-based authentication considered "stateless," and why does this matter for REST APIs?**
   A JWT carries all the information needed to verify it (a signature) and to identify the user and their permissions (claims like `sub` and `roles`) directly within the token itself — the server verifies the signature and reads the claims on every request, with no need to look anything up in a database or an in-memory session store. This directly satisfies REST's statelessness constraint (Lesson 01): any server instance behind a load balancer can independently verify any request's token with no shared, server-side session state to keep in sync — a genuine scalability advantage over traditional session-cookie authentication, which requires the server (or a shared session store) to remember each active session.

## Recommended Next Lesson

[05 — Testing a REST API](../05-Testing-a-REST-API/README.md)
