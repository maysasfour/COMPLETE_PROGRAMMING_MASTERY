// A tiny, dependency-free app that exposes real metrics in Prometheus's own
// text exposition format at /metrics -- no client library needed to prove the
// format itself; a real client library (e.g. prom-client, micrometer) would
// generate the same shape of output, just with less code to write by hand.
const http = require('node:http');

const requestsTotal = {}; // { "route|status": count }
const durationBuckets = [0.01, 0.05, 0.1, 0.5, 1, 2.5];
const durationHistogram = { buckets: durationBuckets.map(() => 0), sum: 0, count: 0 };

function recordRequest(route, status, durationSeconds) {
  const key = `${route}|${status}`;
  requestsTotal[key] = (requestsTotal[key] || 0) + 1;

  durationHistogram.sum += durationSeconds;
  durationHistogram.count += 1;
  durationBuckets.forEach((bucket, i) => {
    if (durationSeconds <= bucket) durationHistogram.buckets[i] += 1;
  });
}

function renderMetrics() {
  const lines = [];

  lines.push('# HELP app_http_requests_total Total HTTP requests handled.');
  lines.push('# TYPE app_http_requests_total counter');
  for (const [key, count] of Object.entries(requestsTotal)) {
    const [route, status] = key.split('|');
    lines.push(`app_http_requests_total{route="${route}",status="${status}"} ${count}`);
  }

  lines.push('# HELP app_http_request_duration_seconds Request duration in seconds.');
  lines.push('# TYPE app_http_request_duration_seconds histogram');
  // Each bucket in `durationHistogram.buckets` is already a CUMULATIVE count --
  // recordRequest() increments every bucket >= the observed duration, which is
  // exactly what Prometheus's histogram format requires (each `le` bucket
  // counts all observations <= that bound, including smaller buckets' counts).
  // A first version of this function summed buckets[i] again here on top of
  // that, double-cumulating and producing bucket values that impossibly
  // exceeded the total request count -- caught immediately by comparing the
  // real curled /metrics output against the actual number of requests sent.
  durationBuckets.forEach((bucket, i) => {
    lines.push(`app_http_request_duration_seconds_bucket{le="${bucket}"} ${durationHistogram.buckets[i]}`);
  });
  lines.push(`app_http_request_duration_seconds_bucket{le="+Inf"} ${durationHistogram.count}`);
  lines.push(`app_http_request_duration_seconds_sum ${durationHistogram.sum}`);
  lines.push(`app_http_request_duration_seconds_count ${durationHistogram.count}`);

  return lines.join('\n') + '\n';
}

const server = http.createServer((req, res) => {
  const start = process.hrtime.bigint();
  const route = req.url.split('?')[0];

  function finish(status, body, contentType = 'text/plain') {
    const durationSeconds = Number(process.hrtime.bigint() - start) / 1e9;
    if (route !== '/metrics') {
      recordRequest(route, status, durationSeconds);
    }
    res.writeHead(status, { 'Content-Type': contentType });
    res.end(body);
  }

  if (route === '/metrics') {
    finish(200, renderMetrics(), 'text/plain; version=0.0.4');
  } else if (route === '/error') {
    finish(500, 'simulated error\n');
  } else if (route === '/slow') {
    setTimeout(() => finish(200, 'slow response\n'), 150);
  } else {
    finish(200, 'ok\n');
  }
});

const port = 5000;
server.listen(port, () => console.log(`app listening on http://localhost:${port}`));
