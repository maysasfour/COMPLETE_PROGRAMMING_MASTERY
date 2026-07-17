# 04 — Monitoring with Prometheus

[Back to 18-DevOps-and-Cloud](../README.md)

## What This Lesson Covers

- **The Prometheus text exposition format**: metrics are just plain text at an HTTP endpoint (`/metrics`), in a specific, simple format — `metric_name{label="value"} number`, with `# HELP`/`# TYPE` comment lines. [`app/app.js`](app/app.js) generates this format **by hand**, with no client library, specifically to make the format itself concrete rather than hidden behind a library call. A real client library (Prometheus's own `prom-client` for Node, Micrometer for Java/Spring Boot) produces the exact same shape of output — this lesson just writes it manually once to show what those libraries are actually doing underneath.
- **Counters vs. histograms**: `app_http_requests_total` is a **counter** — it only ever goes up, labeled by route and status, so a rate of errors can be computed later. `app_http_request_duration_seconds` is a **histogram** — a set of buckets, each counting how many observations fell at or below a given threshold (`le`, "less than or equal"), plus a running `_sum` and `_count`. Histograms are what let you later ask "what's the 95th-percentile latency?" without having stored every individual request's exact duration.
- **Prometheus's pull model**: Prometheus doesn't receive metrics pushed to it — it **scrapes** (polls) each configured target's `/metrics` endpoint on an interval ([`prometheus.yml`](prometheus.yml) uses `2s`, deliberately aggressive so results appear quickly in this lesson; a real deployment would use something like `15s`–`60s`).
- **PromQL**: Prometheus's own query language, run against the real, scraped time-series data via its HTTP API — this lesson runs both an instant counter query and a real `histogram_quantile()` p95 latency calculation.
- **No Docker needed**: both the app and Prometheus itself run as plain native processes — `prometheus.exe` downloaded as a standalone Windows zip from Prometheus's GitHub releases, no container runtime involved at all.

## A Real Bug Found and Fixed

The first version of `renderMetrics()` in `app.js` produced **impossible** histogram output — bucket counts that grew multiplicatively instead of monotonically, exceeding the total request count:

```
app_http_request_duration_seconds_bucket{le="0.01"} 7
app_http_request_duration_seconds_bucket{le="0.05"} 14
app_http_request_duration_seconds_bucket{le="0.1"} 21
...
app_http_request_duration_seconds_count 8   <- buckets already exceed this!
```

**Root cause**: `recordRequest()` already increments *every* bucket `>= the observed duration` per request — meaning each `durationHistogram.buckets[i]` value is already a running cumulative count. The first version of `renderMetrics()` additionally summed those already-cumulative values on top of each other (`cumulative += durationHistogram.buckets[i]`), double-cumulating. **Fix**: output each bucket's value directly, with no additional summation — see the comment at the fix site in `app.js`. Verified after the fix: buckets are correctly non-decreasing and cap exactly at the real total count of 8.

## Files

- [`app/app.js`](app/app.js) — the instrumented sample app.
- [`prometheus.yml`](prometheus.yml) — the real Prometheus scrape config.

## How to Run

```bash
cd 18-DevOps-and-Cloud/04-Monitoring-with-Prometheus

node app/app.js &
prometheus --config.file=prometheus.yml --storage.tsdb.path=./data
```

Then visit `http://localhost:9090` for Prometheus's own web UI, or query its HTTP API directly (see below).

## Verified Behavior (Real Output)

**The hand-rolled `/metrics` endpoint, after the fix, produces a genuinely valid histogram** (5 fast requests to `/`, 1 slow ~150ms request to `/slow`, 2 requests to `/error`):
```
$ curl http://localhost:5000/metrics
app_http_requests_total{route="/",status="200"} 5
app_http_requests_total{route="/slow",status="200"} 1
app_http_requests_total{route="/error",status="500"} 2
app_http_request_duration_seconds_bucket{le="0.01"} 7
app_http_request_duration_seconds_bucket{le="0.05"} 7
app_http_request_duration_seconds_bucket{le="0.1"} 7
app_http_request_duration_seconds_bucket{le="0.5"} 8
app_http_request_duration_seconds_bucket{le="1"} 8
app_http_request_duration_seconds_bucket{le="2.5"} 8
app_http_request_duration_seconds_count 8
```
The `/slow` request's ~150ms duration correctly lands between the `0.1` and `0.5` buckets — 7 requests at or under 0.1s, 8 (all of them) at or under 0.5s.

**Prometheus genuinely scrapes this endpoint** — its own target-health API reports the real scrape as `up`:
```
$ curl http://localhost:9090/api/v1/targets
"health": "up", "scrapeUrl": "http://localhost:5000/metrics", "lastError": ""
```

**A real instant PromQL query against the scraped data** (after sending 10 more requests to `/`):
```
$ curl 'http://localhost:9090/api/v1/query?query=app_http_requests_total'
{"route":"/","status":"200"} -> 15
{"route":"/slow","status":"200"} -> 1
{"route":"/error","status":"500"} -> 2
```

**A real `histogram_quantile()` p95 latency calculation**, computed by Prometheus's own query engine from the scraped histogram buckets, not hand-calculated:
```
$ curl -G 'http://localhost:9090/api/v1/query' \
    --data-urlencode 'query=histogram_quantile(0.95, sum(rate(app_http_request_duration_seconds_bucket[1m])) by (le))'
{"value": [..., "0.0095"]}
```

## Suggested Improvements / Next Steps

A real deployment would use a proper client library (Micrometer's `PrometheusMeterRegistry` for the Spring Boot apps already built in `22-Projects`, for instance) rather than hand-rolled text generation, and would pair Prometheus with Grafana for dashboards/alerting — both skipped here to keep this lesson's scope to genuinely running, hand-verifiable pieces without Docker.

Continue to [05-Cloud-Fundamentals](../05-Cloud-Fundamentals/README.md) — the conceptual groundwork (IaaS/PaaS/SaaS, major providers, scaling and cost trade-offs) that this repository covers in place of assuming access to a real, paid cloud account.

**Previous lesson:** [03-Reverse-Proxy-and-Load-Balancing-with-Nginx](../03-Reverse-Proxy-and-Load-Balancing-with-Nginx/README.md)
**Next lesson:** [05-Cloud-Fundamentals](../05-Cloud-Fundamentals/README.md)
