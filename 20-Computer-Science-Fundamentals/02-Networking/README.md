# 02 — Networking (TCP/IP, DNS, HTTP)

[Back to module overview](../README.md) | [Previous: Binary/Hex and Boolean Logic](../01-Binary-Hex-and-Boolean-Logic/README.md)

## Beginner: A Real DNS Lookup

DNS translates human-readable hostnames into the IP addresses computers actually use to route traffic. This lesson performs a **genuinely real** DNS lookup (network access permitting), and then proves something conceptually important with real, working code: **HTTP is just a text protocol sent over a plain TCP connection** — nothing more.

## Real DNS Resolution

```java
InetAddress[] addresses = InetAddress.getAllByName("dns.google");
```

Verified live, with a genuine network lookup:

```
localhost resolves to: 127.0.0.1
dns.google resolves to 4 real address(es):
  8.8.8.8
  8.8.4.4
  2001:4860:4860:0:0:0:0:8844
  2001:4860:4860:0:0:0:0:8888
```

`dns.google` genuinely resolves to Google's real public DNS server addresses (both IPv4 and IPv6) — this is a real DNS query resolved by the operating system's real resolver, not a hardcoded value.

## HTTP Is Genuinely Just Text Over TCP

```java
Socket socket = new Socket("localhost", port);
String rawRequest = "GET /hello HTTP/1.1\r\n" +
        "Host: localhost\r\n" +
        "Connection: close\r\n" +
        "\r\n";
socket.getOutputStream().write(rawRequest.getBytes());
```

No `HttpClient`, no HTTP library of any kind — just a raw `Socket` and a manually-written string, sent as raw bytes. Verified live, against a real `HttpServer`:

```
Raw bytes being written directly to the TCP socket:
---
GET /hello HTTP/1.1
Host: localhost
Connection: close

---
Raw bytes received back over the SAME plain TCP socket:
---
HTTP/1.1 200 OK
Date: Fri, 17 Jul 2026 00:44:22 GMT
Content-length: 25

Hello from a real server!

---
```

The real `HttpServer` correctly understood and responded to a request that was never built using any HTTP-specific API — just a `Socket` and a specifically-formatted piece of text. This is real, direct proof that HTTP's request/response format is just a text convention layered on top of a plain TCP byte stream: the method, path, version, headers, and a blank line separating headers from body — nothing magic, nothing binary, nothing that couldn't be typed by hand.

## Detailed Example

See [Example.java](Example.java) — real DNS resolution and a real raw-socket HTTP request/response round trip.

## Run It

```bash
cd 20-Computer-Science-Fundamentals/02-Networking
javac Example.java
java Example
```

(Requires network access for the `dns.google` lookup to succeed; the raw-socket HTTP demo works fully offline against the local server it starts.)

## Expected Output

Real resolved IP addresses for `localhost` and `dns.google`; a manually-crafted, real HTTP request sent over a raw socket, and a real, correctly-formatted HTTP response received back — all without any HTTP library involved in constructing or sending the request.

## Common Mistakes

- Treating HTTP as some kind of special, opaque binary protocol — verified live that a request built from nothing but a plain string, sent over a raw `Socket`, was correctly understood by a real server.
- Assuming DNS resolution always returns exactly one address — verified live that `dns.google` genuinely resolves to multiple real addresses (both IPv4 and IPv6).
- Forgetting the blank line (`\r\n\r\n`) separating HTTP headers from the body — this is not cosmetic; it's how a real HTTP parser knows where headers end, and omitting it would break the raw request demonstrated here.

## Best Practices

- Use a real HTTP client library (like `HttpClient`, used throughout this repository's other networking lessons) for real applications — this lesson's raw-socket approach is for understanding what's happening underneath, not a recommended way to build real HTTP clients.
- Understand that DNS can return multiple addresses for one hostname (for load balancing/redundancy), and real clients should be prepared to try more than one if the first fails.
- Use `\r\n` (not just `\n`) for HTTP line endings, per the actual HTTP specification, as this lesson's raw request does.

## Real-World Usage

Understanding that HTTP is fundamentally text over TCP demystifies an enormous amount of web infrastructure — every HTTP client library, proxy, and load balancer is ultimately just correctly implementing (and optimizing around) this same simple text format. This foundational understanding directly underlies every HTTP-based lesson elsewhere in this repository (see [04-Backend-Development](../../04-Backend-Development/README.md), [14-APIs-and-Integrations](../../14-APIs-and-Integrations/README.md)).

## Summary

- A real DNS lookup resolved `dns.google` to multiple genuine, real IP addresses.
- HTTP was proven, live, to be nothing more than a specifically-formatted text string sent over a plain TCP socket — a real `HttpServer` correctly understood and responded to a request built with zero HTTP-specific code.

## Key Terms

- **DNS (Domain Name System)** — the system that translates hostnames into IP addresses.
- **TCP (Transmission Control Protocol)** — a reliable, ordered, byte-stream protocol that HTTP (among many other protocols) is built on top of.
- **Socket** — an endpoint for network communication, used here to send and receive raw bytes directly, without any HTTP abstraction.

## Interview Questions

1. **In what sense is HTTP "just text over TCP," and how was this proven with real, working code rather than just asserted?**
   HTTP defines a specific text format for requests and responses (a method/path/version line, headers, a blank line, then an optional body) sent over an underlying, reliable byte-stream connection — TCP. This was proven concretely: a request was constructed as a plain Java string (`"GET /hello HTTP/1.1\r\n..."`), written directly to a raw `Socket`'s output stream with no HTTP library of any kind involved, and a real, unmodified `HttpServer` correctly parsed and responded to it — verified by reading the real, correctly-formatted HTTP response back over that same raw socket.

2. **Why can a single hostname resolve to multiple IP addresses, and how was this demonstrated?**
   DNS can return multiple addresses for one hostname for load balancing, redundancy, and to support both IPv4 and IPv6 clients — a client is expected to try one and fall back to another if needed, rather than assuming exactly one address exists. This was demonstrated concretely: resolving `dns.google` returned four real, distinct addresses — two IPv4 (`8.8.8.8`, `8.8.4.4`) and two IPv6 — verified directly via `InetAddress.getAllByName()`'s actual returned array, not a single hardcoded address.

## Recommended Next Lesson

[03 — OS Fundamentals](../03-OS-Fundamentals/README.md)
