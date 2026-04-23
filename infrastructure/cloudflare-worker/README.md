# Dispensary Path Router (Cloudflare Worker)

Routes traffic on a dispensary's custom domain between CanopySync and WordPress.

## How it works

- `dispensary.com/` → CanopySync (home page, menu, shop pages)
- `dispensary.com/product/*`, `/brand/*`, `/collection/*`, `/strains/*` → CanopySync
- `dispensary.com/blog/*` and all other paths → WordPress

## Setup per dispensary

1. Install wrangler: `npm install -g wrangler`
2. Copy this directory
3. Update wrangler.toml with the dispensary's:
   - CANOPYSYNC_ORIGIN (their Fly.io app URL)
   - WORDPRESS_ORIGIN (their WordPress host)
4. Deploy: `wrangler deploy`
5. In Cloudflare dashboard, add a Worker Route:
   - Route: `dispensary.com/*`
   - Worker: `dispensary-router`
6. Ensure the dispensary's domain DNS is proxied through Cloudflare (orange cloud)

## Adding/removing CanopySync paths

Edit the CANOPYSYNC_PATHS array in router.js. Any path not matched
falls through to WordPress.

## Per-dispensary customization

Each dispensary may have different informational pages in CanopySync vs WordPress.
Clone this worker per dispensary and adjust CANOPYSYNC_PATHS as needed.
Alternatively, store path config in Cloudflare KV for a single shared worker.

## Notes

- The worker passes X-Forwarded-Host so CanopySync resolves the correct shop
- Static assets are cached for 1 year with immutable flag
- Sitemaps and robots.txt are routed to CanopySync since it controls SEO
