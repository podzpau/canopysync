# Known Failing Tests (pre-existing, not regressions)

- test/models/brand_test.rb:43,50 — seo_focus_keyword missing column
- test/models/product_test.rb:73,79 — seo_focus_keyword missing column  
- test/controllers/storefront/noindex_test.rb — 406 on collection routes
- test/controllers/storefront/products_controller_test.rb:9 — 406
- test/controllers/storefront/sitemaps_controller_test.rb:112-127 — 406
- RuntimeError: Missing partial storefront/shared/_ribbon
