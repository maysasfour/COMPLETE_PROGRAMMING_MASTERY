# 08 — Next.js Fundamentals

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

Next.js is a framework *built on top of* React — everything from Lessons 01–07 (components, hooks, JSX) still applies, but Next.js changes **where and when** that code runs.

- **File-based routing (App Router)**: `app/page.js` is the `/` route; `app/users/[id]/page.js` is a dynamic route. There is no `<Routes>`/`<Route>` config to write by hand (contrast with Lesson 05's `react-router-dom`) — the folder structure *is* the routing table.
- **Server Components by default**: `app/page.js` is an `async` function that `await fetch(...)`s directly in the component body — no `useState`/`useEffect`/loading-state juggling like Lesson 05's `UserList` needed, because this code runs **on the server**, before any HTML reaches the browser. The fetched data is already baked into the HTML response.
- **Route Handlers**: `app/api/health/route.js` is a real backend endpoint living in the same project as the frontend — Next.js blurs the frontend/backend line by letting a single project ship both.
- **`notFound()`**: calling it inside a Server Component renders the framework's 404 page and sets a real `404` HTTP status — used in `users/[id]/page.js` when the fetched user doesn't exist.

## A Real Breaking-Change Gotcha, Caught Before Writing Any Code

This project scaffolded **Next.js 16.2.10** — a version newer than this assistant's own training data, and the scaffold itself ships an `AGENTS.md` file warning exactly that: *"This version has breaking changes — APIs, conventions, and file structure may all differ from your training data."* Rather than guess, the bundled docs at `node_modules/next/dist/docs/01-app/03-api-reference/03-file-conventions/dynamic-routes.md` were read first, which surfaced a genuine, easy-to-get-wrong change: **`params` is now a `Promise`**, not a plain object. `const { id } = await params` is required in `users/[id]/page.js` — older Next.js docs (and most training data) show `params.id` accessed synchronously, which would silently be `undefined` (or throw) on this version. This is called out directly in that file's own comment, not smoothed over.

## Files

- [`app/page.js`](app/page.js) — the home route, a Server Component fetching directly.
- [`app/users/[id]/page.js`](app/users/[id]/page.js) — a dynamic route, including the `await params` gotcha above and `notFound()`.
- [`app/api/health/route.js`](app/api/health/route.js) — a Route Handler.
- [`next.config.mjs`](next.config.mjs) — one small fix: `turbopack.root` silences a workspace-root warning caused by an unrelated `package-lock.json` in a parent directory outside this lesson.

## How to Run

```bash
cd 03-Frontend-Development/08-Next.js-Fundamentals
npm install
npm run dev      # http://localhost:3000, with Hot Module Replacement
```

## Verified Behavior (Real Output)

**Production build succeeds, and correctly identifies which routes are static vs. dynamic:**
```
$ npm run build
✓ Compiled successfully in 5.7s
Route (app)
┌ ƒ /
├ ○ /_not-found
├ ƒ /api/health
└ ƒ /users/[id]
```

**The single most important difference from Lesson 01's Vite SPA — proven with plain `curl`, no headless browser needed at all**, because the content is genuinely server-rendered rather than requiring client-side JS to hydrate first:
```
$ curl -s http://localhost:3000
...<main><h1>Users (fetched server-side)</h1><ul>
<li><a href="/users/1">Leanne Graham</a></li>
<li><a href="/users/2">Ervin Howell</a></li>
... (all 10 real users, already in the raw HTML response)
```

**The dynamic route correctly resolves `await params` and fetches the matching user:**
```
$ curl -s http://localhost:3000/users/1
<h1>Leanne Graham</h1><p>Sincere@april.biz</p><p>Romaguera-Crona</p>
```

**A nonexistent user correctly 404s** (via `notFound()`):
```
$ curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000/users/9999
404
```

**The Route Handler returns real JSON from a real backend endpoint in the same project:**
```
$ curl -s http://localhost:3000/api/health
{"status":"ok","timestamp":"2026-07-17T12:00:03.833Z"}
```

## Suggested Improvements / Next Steps

Continue to [09-Other-Frameworks](../09-Other-Frameworks/README.md) — a brief, honest look at Vue (with a small, real, runnable example) to see which React/Next.js concepts carry over directly and which don't, rather than treating React as the only way to build a frontend.

**Previous lesson:** [07-Testing](../07-Testing/README.md)
