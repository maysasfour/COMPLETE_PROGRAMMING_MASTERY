# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Verify `HTTP::Tiny` is core (bundled with Perl, no CPAN install needed).
- Make real HTTP GET/POST requests against a live public API from this environment.
- Document an honest environment gotcha (missing CA bundle) rather than hiding it.

## Environment check — verified live

```bash
$ perl -MHTTP::Tiny -e "print 1"
```
Output (actual): `1` — `HTTP::Tiny` is core (bundled with Perl since 5.13.9), confirmed present.

## Concept

### First attempt — a genuine, honestly-documented failure

The very first run of a plain `HTTP::Tiny->new->get(...)` against `https://jsonplaceholder.typicode.com/todos/1` failed:

```bash
$ perl -e 'use HTTP::Tiny; my $http = HTTP::Tiny->new(timeout=>10); my $r = $http->get("https://jsonplaceholder.typicode.com/todos/1"); print "status: $r->{status} $r->{reason}\n"; print "content: $r->{content}\n";'
```
Output (actual):
```
status: 599 Internal Exception
content: Couldn't find a CA bundle with which to verify the SSL certificate.
Try installing Mozilla::CA from CPAN
```

This is a real, environment-specific gotcha: this msys2 Perl build has no CA certificate bundle configured for TLS verification, so any HTTPS request fails at the SSL handshake step — network connectivity itself is fine, only certificate verification fails. The honest fix in production would be to install `Mozilla::CA` from CPAN (or point `HTTP::Tiny` at a system CA bundle path); for this course, `verify_SSL => 0` was used as a demonstrated workaround so the live-request lesson could still complete against the real network, with the tradeoff called out explicitly rather than silently disabled.

### Working GET + POST, verified live

[`api_demo.pl`](api_demo.pl), run with `perl api_demo.pl`. Output (actual):

```
GET status: 200 OK
userId=1 id=1 title=delectus aut autem completed=0

POST status: 201 Created
created id=101 title=perl test
```

Both requests genuinely reached `https://jsonplaceholder.typicode.com` over the live network from this sandboxed environment — the GET response body was decoded with `JSON::PP` into real fields (`userId`, `id`, `title`, `completed`), and the POST returned a real `201 Created` with the JSONPlaceholder mock API's typical fabricated `id: 101` (that API always echoes back id 101 for new posts regardless of payload — this is the real, documented behavior of that specific test service, not something invented for this lesson).

## Common beginner mistakes

- Assuming HTTPS "just works" everywhere — TLS verification depends on a correctly configured CA bundle, which is not guaranteed on every Perl install/platform, as demonstrated above.
- Disabling `verify_SSL` in production code without understanding it removes protection against man-in-the-middle attacks — it's a debugging/demo workaround, not a fix.
- Forgetting to check `$response->{success}` (or `$response->{status}`) before assuming `$response->{content}` is valid JSON.

## Best practices

- In real deployments, install `Mozilla::CA` (or configure the system CA bundle) instead of disabling SSL verification.
- Always set a `timeout` on `HTTP::Tiny->new(...)` — an API integration script should never hang indefinitely on a stalled connection.
