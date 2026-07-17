// A Route Handler: Next.js's built-in way to expose a real backend endpoint
// from the SAME project as the frontend, without a separate server. Visiting
// /api/health returns real JSON, not a rendered page -- this is genuinely a
// server-side-only file; it never ships to the browser bundle at all.
export async function GET() {
  return Response.json({ status: 'ok', timestamp: new Date().toISOString() })
}
