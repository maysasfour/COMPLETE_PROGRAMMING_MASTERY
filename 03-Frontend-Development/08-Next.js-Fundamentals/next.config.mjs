/** @type {import('next').NextConfig} */
const nextConfig = {
  // Silences a workspace-root inference warning caused by an unrelated
  // package-lock.json in a parent directory (outside this lesson's project).
  turbopack: {
    root: import.meta.dirname,
  },
};

export default nextConfig;
