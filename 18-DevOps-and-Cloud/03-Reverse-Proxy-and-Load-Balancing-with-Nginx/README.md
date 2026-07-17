# 03 — Reverse Proxy and Load Balancing with Nginx

[Back to 18-DevOps-and-Cloud](../README.md)

## What This Lesson Covers

- **Reverse proxy**: a server that sits in front of one or more backend servers and forwards client requests to them, so clients only ever talk to one address (the proxy) regardless of how many backends actually exist or where they run.
- **Load balancing**: when there's more than one backend, the reverse proxy also decides *which* backend gets each request. Nginx's default algorithm is round-robin — this lesson proves it actually cycles through backends in order, not just asserts that it does.
- **Automatic failover**: if a backend stops responding, nginx marks it as failed (`max_fails`/`fail_timeout` in the `upstream` block) and stops sending it traffic until it recovers — verified here by **actually killing a real backend process** mid-demo and confirming client requests keep succeeding, transparently routed to the two survivors.
- **Nginx running natively, no Docker**: a real `nginx.exe` for Windows, downloaded as a plain zip from nginx.org and run directly — the same core reverse-proxy/load-balancing behavior as a containerized nginx, without needing Docker at all.

## Files

- [`backend/server.js`](backend/server.js) — a minimal dependency-free Node HTTP server; each instance identifies itself by its own port, so it's possible to see *which* backend answered each request.
- [`conf/nginx.conf`](conf/nginx.conf) — the real nginx config: an `upstream backend_pool` of three backends, and a `server` block reverse-proxying `:8090` to that pool.

## How to Run

```bash
cd 18-DevOps-and-Cloud/03-Reverse-Proxy-and-Load-Balancing-with-Nginx

# Start three real backend processes:
node backend/server.js 4001 &
node backend/server.js 4002 &
node backend/server.js 4003 &

# Start nginx pointed at this lesson's own config/log/temp directories:
nginx -c "$(pwd)/conf/nginx.conf" -p "$(pwd)/"

# Send requests through the load balancer:
curl http://localhost:8090
```

(`nginx.exe` was downloaded as a standalone Windows zip from nginx.org — no installer, no Docker, no admin rights needed. `-p` sets nginx's "prefix" so its `logs/`/`temp/` directories stay inside this lesson rather than the shared system-wide install.)

## Verified Behavior (Real Output)

**Round-robin load balancing — six consecutive requests correctly cycle through all three real backends in order:**
```
$ for i in 1 2 3 4 5 6; do curl -s http://localhost:8090; echo; done
{"server":"backend-4002","port":4002,"pid":30848}
{"server":"backend-4003","port":4003,"pid":21420}
{"server":"backend-4001","port":4001,"pid":15932}
{"server":"backend-4002","port":4002,"pid":30848}
{"server":"backend-4003","port":4003,"pid":21420}
{"server":"backend-4001","port":4001,"pid":15932}
```

**A genuine failover** — backend-4002's real OS process is killed via `taskkill`, then six more requests are sent:
```
$ taskkill /PID 30848 /F
SUCCESS: The process with PID 30848 has been terminated.

$ for i in 1 2 3 4 5 6; do curl -s http://localhost:8090; echo; done
{"server":"backend-4003","port":4003,"pid":21420}
{"server":"backend-4003","port":4003,"pid":21420}
{"server":"backend-4001","port":4001,"pid":15932}
{"server":"backend-4003","port":4003,"pid":21420}
{"server":"backend-4001","port":4001,"pid":15932}
{"server":"backend-4003","port":4003,"pid":21420}
```

Every single request still succeeded — `backend-4002` never appears again, and nginx's own error log shows exactly why, a real connection-refused error against the killed process, followed by an automatic retry against a healthy backend:
```
[error] connect() failed (10061: No connection could be made because the target
machine actively refused it) while connecting to upstream, ... upstream:
"http://127.0.0.1:4002/", host: "localhost:8090"
```

The client (`curl`) never saw an error at all — this transparency is the entire point of a load balancer with failover.

## Suggested Improvements / Next Steps

Continue to [04-Monitoring-with-Prometheus](../04-Monitoring-with-Prometheus/README.md) — a real Prometheus instance (also running natively, no Docker) scraping live metrics from a real application.

**Previous lesson:** [02-Infrastructure-as-Code-with-Terraform](../02-Infrastructure-as-Code-with-Terraform/README.md)
**Next lesson:** [04-Monitoring-with-Prometheus](../04-Monitoring-with-Prometheus/README.md)
