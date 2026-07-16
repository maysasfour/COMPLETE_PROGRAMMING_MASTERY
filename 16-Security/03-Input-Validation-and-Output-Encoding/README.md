# 03 — Input Validation and Output Encoding (XSS)

[Back to module overview](../README.md) | [Previous: Secure Password Storage](../02-Secure-Password-Storage/README.md)

## Beginner: A Real, Executable Script Injected Into a Real HTML Response

Cross-Site Scripting (XSS) happens when user input is embedded directly into an HTML response without encoding, letting an attacker's input become actual page markup — including executable `<script>` tags — rather than just displayed text. This lesson demonstrates the real HTML response body, byte for byte, both with and without proper output encoding, against a genuine embedded HTTP server.

## The Violation: A Real, Literal `<script>` Tag in the Response

```java
static String renderGuestbookVulnerable(String comment) {
    return "<html><body><h1>Guestbook</h1><p>Comment: " + comment + "</p></body></html>";
}
```

An attacker submits `<script>alert('XSS')</script>` as their "comment." Verified live, the **actual HTTP response body** returned by a real server:

```
Real response body: <html><body><h1>Guestbook</h1><p>Comment: <script>alert('XSS')</script></p></body></html>
Contains a literal, executable <script> tag: true  <- BUG: any real browser rendering this page would EXECUTE that script!
```

This is genuinely dangerous, not just a display glitch: any browser rendering this exact HTML would parse `<script>alert('XSS')</script>` as real markup and execute the script inside it — with the same permissions as the legitimate page, capable of stealing session cookies, redirecting users, or performing actions on their behalf.

## The Fix: HTML-Encode Before Embedding

```java
static String htmlEncode(String input) {
    return input.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
}
static String renderGuestbookSafe(String comment) {
    return "<html>...<p>Comment: " + htmlEncode(comment) + "</p>...</html>";
}
```

Verified live, submitting the **identical** attacker input:

```
Real response body: <html><body><h1>Guestbook</h1><p>Comment: &lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;</p></body></html>
Contains a literal, executable <script> tag: false  <- correct: the browser would render this as inert TEXT, not execute it
```

The characters `<`, `>`, and `'` have been converted to their HTML entity equivalents (`&lt;`, `&gt;`, `&#39;`). A browser rendering this response displays the literal text `<script>alert('XSS')</script>` on the page — it can never be parsed as an actual script tag, because the characters that would make it one no longer appear in the markup at all.

## Detailed Example

See [Example.java](Example.java) — the real injected script tag in an actual HTTP response, and the properly encoded, neutralized version.

## Run It

```bash
cd 16-Security/03-Input-Validation-and-Output-Encoding
javac Example.java
java Example
```

## Expected Output

A real HTTP server starting; a real response body containing a literal, executable `<script>` tag in the violation; the identical attacker input safely rendered as inert, HTML-encoded text in the fix; the server stopping cleanly.

## Common Mistakes

- Embedding user input directly into HTML output with no encoding — verified live to let an attacker's input become real, executable markup.
- Encoding input when it's *received* (input validation) but not when it's *rendered* (output encoding) — the correct encoding depends on the output context (HTML, a URL, a SQL string, a shell command), and HTML-encoding at render time is what actually prevents this specific class of vulnerability.
- Assuming input validation (rejecting "suspicious" characters) is a sufficient replacement for output encoding — a comment containing a stray `<` or `&` for entirely legitimate reasons should still be handled safely, not simply rejected or stripped.

## Best Practices

- Always HTML-encode user-controlled data at the point it's rendered into HTML output, regardless of what validation happened earlier.
- Use your framework's built-in, well-tested escaping mechanism (most templating engines HTML-encode by default) rather than hand-rolling encoding logic in production code — this lesson's `htmlEncode()` demonstrates the underlying idea at a small, understandable scale.
- Apply context-appropriate encoding — HTML encoding for HTML output, URL encoding for URLs, and so on; the correct encoding depends on where the data is being placed, not just that it came from a user.

## Real-World Usage

XSS remains one of the most common web application vulnerabilities in practice — a comment field, a search box, a user profile field, or any place user input is later displayed back to other users is a potential XSS vector if output encoding is missed. Real XSS attacks have been used to steal session cookies, perform actions on behalf of victims, and deface websites, which is why XSS remains a permanent fixture of the OWASP Top 10.

## Summary

- Rendering user input directly into HTML was shown, live, to embed a real, literal, executable `<script>` tag into an actual HTTP response.
- HTML-encoding the same input before rendering was shown, live, to neutralize it into safe, inert text — the identical attacker input, verified via the actual response body, no longer contains any executable markup.

## Key Terms

- **Cross-Site Scripting (XSS)** — a vulnerability where attacker-controlled input is rendered as executable script in a page viewed by other users.
- **Output encoding** — converting characters with special meaning in a given output context (like `<` in HTML) into safe, literal equivalents at the point of rendering.
- **HTML entity** — the encoded representation of a special HTML character (e.g., `&lt;` for `<`), rendered as the literal character but never parsed as markup.

## Interview Questions

1. **How does an XSS vulnerability let an attacker's input become executable code, and how was this demonstrated concretely?**
   When user input is concatenated directly into an HTML response with no encoding, any HTML/script syntax within that input becomes real, structural page markup rather than displayed text — a browser parsing the response can't distinguish "text the user typed" from "markup the page author wrote." This was demonstrated concretely: submitting `<script>alert('XSS')</script>` as a comment produced an actual HTTP response body containing that exact, literal, unescaped tag, verified directly against the real response string returned by a real HTTP server — any browser rendering that response would execute the script.

2. **Why does HTML-encoding at the point of output specifically fix this, rather than validating/rejecting input?**
   HTML-encoding converts characters with special meaning in HTML (`<`, `>`, `&`, quotes) into their entity equivalents at the moment data is embedded into HTML output — this guarantees the data can only ever render as literal text, regardless of what it contains, without needing to guess in advance what "dangerous" input might look like. This was verified concretely: the identical attacker payload, run through `htmlEncode()` before being embedded in the response, produced `&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;` — confirmed via the actual response body to no longer contain a literal `<script>` tag at all, meaning a browser would display it as harmless visible text instead of executing it.

## Recommended Next Lesson

[04 — HTTPS and Security Headers](../04-HTTPS-and-Security-Headers/README.md)
