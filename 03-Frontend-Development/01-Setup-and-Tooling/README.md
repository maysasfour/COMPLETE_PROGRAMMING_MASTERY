# 01 — Setup and Tooling

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

Every lesson from here on assumes a working React toolchain — this lesson establishes it and explains what each piece actually does, rather than treating `npm create vite` as a magic incantation.

- Why a **build tool** (Vite) exists at all: browsers don't understand JSX or bare-module imports like `import React from 'react'` without a path; Vite transforms and bundles source into something a browser can actually load.
- **Vite specifically** (vs. older tools like Create React App, which is deprecated): Vite serves source files over native ES modules during development (near-instant startup, since nothing is bundled upfront) and uses Rollup to produce an optimized production bundle only when you actually build.
- The three npm scripts every Vite project ships with: `npm run dev` (development server with Hot Module Replacement), `npm run build` (production bundle in `dist/`), `npm run preview` (serves that production bundle locally, to sanity-check it before deploying).
- Project structure: `index.html` is the real entry point (not an afterthought — Vite treats it as a build input), `src/main.jsx` mounts the React tree into it, `src/App.jsx` is the root component.

## Project Structure

```
01-Setup-and-Tooling/
├── index.html          # real entry point — Vite reads this to find src/main.jsx
├── vite.config.js       # Vite configuration (the @vitejs/plugin-react plugin, for JSX support)
├── package.json         # dev/build/preview scripts + react, react-dom dependencies
├── src/
│   ├── main.jsx         # mounts <App /> into index.html's #root div via createRoot
│   ├── App.jsx           # root component
│   ├── App.css / index.css
│   └── assets/
└── public/               # static files served as-is, unprocessed
```

## How to Run

```bash
cd 03-Frontend-Development/01-Setup-and-Tooling
npm install
npm run dev       # starts a dev server, prints a http://localhost:5173 URL
```

Open the printed URL in a browser. Edit `src/App.jsx`, save, and the page updates instantly without a full reload (Hot Module Replacement) — this alone is Vite's headline feature over older, bundle-everything-upfront tools.

```bash
npm run build      # produces dist/ — an optimized, minified production bundle
npm run preview     # serves dist/ locally so you can check the built output
```

## Verified Behavior (Real Output)

This lesson's toolchain was actually exercised end-to-end in this environment, not just described:

**Production build succeeds:**
```
$ npm run build
vite v8.1.5 building client environment for production...
✓ 20 modules transformed.
dist/index.html                   0.47 kB
dist/assets/index-RUIdmWQI.js   193.35 kB │ gzip: 60.67 kB
✓ built in 408ms
```

**The dev server serves real, working React — verified with a headless Chromium browser (Playwright), not just an HTTP status check:**
```
BODY TEXT: Get started Edit src/App.jsx and save to test HMR Count is 0 Documentation ...
```

**Client-side interactivity genuinely works — a real browser click updates real component state:**
```
before click: Count is 0
after 3 clicks: Count is 3
```

This confirms the full chain actually functions: Vite serves the app, the browser downloads and executes the JS bundle, React hydrates the page, and a click handler correctly triggers a `useState` update and re-render — the same chain every later lesson in this module depends on.

## Suggested Improvements / Next Steps

See [02-Components-JSX-and-Props](../02-Components-JSX-and-Props/README.md) for what actually happens inside `App.jsx` — this lesson deliberately left the default Vite template untouched so the *tooling* stayed the sole focus.
