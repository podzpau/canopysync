/**
 * CanopySync Path Router
 *
 * Deployed as a Cloudflare Worker on the dispensary's domain.
 * Routes requests to either CanopySync (Fly.io) or WordPress
 * based on URL path.
 *
 * Configuration:
 *   CANOPYSYNC_ORIGIN = "https://{app-name}.fly.dev"
 *   WORDPRESS_ORIGIN  = "https://{wp-host}.com"
 *
 * Set these as environment variables in Cloudflare Worker settings.
 */

const CANOPYSYNC_PATHS = [
  '/',
  '/menu',
  '/product/',
  '/brand/',
  '/collection/',
  '/strains/',
  '/cart/',
  '/search/',
  '/html-sitemap/',
  '/sitemap',
  '/robots.txt',
  '/about/',
  '/faq/',
  '/contact/',
  '/deals/',
  '/find-dispensary/',
  '/rewards/',
];

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    const isCanopySync = path === '/' || CANOPYSYNC_PATHS.some(prefix => {
      if (prefix === '/') return false; // already handled
      return path.startsWith(prefix);
    });

    const origin = isCanopySync ? env.CANOPYSYNC_ORIGIN : env.WORDPRESS_ORIGIN;

    const originUrl = new URL(path + url.search, origin);

    const newRequest = new Request(originUrl, {
      method: request.method,
      headers: request.headers,
      body: request.body,
      redirect: 'follow',
    });

    // Pass the original host so CanopySync can resolve the correct shop
    newRequest.headers.set('X-Forwarded-Host', url.hostname);
    newRequest.headers.set('X-Original-Host', url.hostname);

    const response = await fetch(newRequest);

    // Clone response so we can modify headers
    const newResponse = new Response(response.body, response);

    // Remove any x-frame-options that might interfere
    newResponse.headers.delete('x-frame-options');

    // Cache static assets aggressively
    if (path.match(/\.(css|js|png|jpg|jpeg|gif|svg|woff2?|ttf|ico)$/)) {
      newResponse.headers.set('Cache-Control', 'public, max-age=31536000, immutable');
    }

    return newResponse;
  },
};
