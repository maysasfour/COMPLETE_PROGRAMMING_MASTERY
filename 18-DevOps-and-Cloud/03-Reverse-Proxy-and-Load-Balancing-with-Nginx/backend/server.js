// A minimal backend using only Node's built-in http module -- no dependencies
// to install. Each instance identifies itself by the port it was started on,
// so curling the load balancer repeatedly and watching WHICH backend answers
// each time is how round-robin distribution (and later, failover) gets proven.
const http = require('node:http');

const port = Number(process.argv[2]);
if (!port) {
  console.error('Usage: node server.js <port>');
  process.exit(1);
}

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ server: `backend-${port}`, port, pid: process.pid }));
});

server.listen(port, () => {
  console.log(`backend-${port} listening on http://localhost:${port} (pid ${process.pid})`);
});
