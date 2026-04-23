# Storefront demo seed — idempotent (find_or_create_by slug+shop_id)
# Run: bin/rails runner db/seeds_storefront_demo.rb

shop = Shop.first
abort "No shop found — run bin/rails db:seed first" unless shop

# SeoScorable calls seo_focus_keyword and self.seo_score= which don't exist
# as DB columns yet. Patch them for this process so saves succeed.
[Brand, Product, Collection].each do |model|
  model.class_eval do
    def seo_focus_keyword; nil; end
    def seo_score=(_val); end  # no-op until column is migrated
  end
end

puts "\n=== Seeding storefront demo data for: #{shop.name} (id=#{shop.id}) ===\n\n"

created_brands      = 0
created_collections = 0
created_products    = 0

# ─────────────────── BRANDS ───────────────────

brand_data = [
  {
    name: "Cookies",
    slug: "cookies",
    description: "Founded by Berner and Jai in San Francisco, Cookies is one of the most recognized cannabis brands in the world. Known for exclusive genetics and a culture that bridges hip-hop and premium cannabis.",
    logo_url: nil,
    website_url: "https://cookies.co",
    instagram_url: "https://instagram.com/cookiessf"
  },
  {
    name: "Stiiizy",
    slug: "stiiizy",
    description: "STIIIZY is California's premier vape brand, engineered with a proprietary pod system for consistent, clean vapor. Their lineup spans from high-potency live resin to broad spectrum wellness formulations.",
    logo_url: nil,
    website_url: "https://stiiizy.com",
    instagram_url: "https://instagram.com/stiiizy"
  },
  {
    name: "Raw Garden",
    slug: "raw-garden",
    description: "Raw Garden sets the standard for California cannabis. Every product is made from certified clean cannabis — no pesticides, no cutting agents, just pure live resin extracted from fresh-frozen flower.",
    logo_url: nil,
    website_url: "https://rawgarden.farm",
    instagram_url: "https://instagram.com/rawgarden"
  },
  {
    name: "Kiva",
    slug: "kiva",
    description: "Kiva Confections has been crafting premium cannabis-infused edibles since 2010. From their iconic Terra bites to precisely dosed mints and tarts, Kiva is synonymous with approachable, reliable edibles.",
    logo_url: nil,
    website_url: "https://kivaconfections.com",
    instagram_url: "https://instagram.com/kivaconfections"
  },
  {
    name: "Select",
    slug: "select",
    description: "Select is driven by purity. Their distillate and live resin oils are extracted using a proprietary refinement process that delivers a clean, consistent experience every time.",
    logo_url: nil,
    website_url: "https://selectcannabis.com",
    instagram_url: "https://instagram.com/selectcannabis"
  },
  {
    name: "Wyld",
    slug: "wyld",
    description: "Wyld makes real fruit gummies and sparkling beverages with consistently dosed cannabinoids. Inspired by the wild places of the Pacific Northwest, their products are clean, natural, and made for the outdoors.",
    logo_url: nil,
    website_url: "https://wyldcbd.com",
    instagram_url: "https://instagram.com/wyldcannabis"
  }
]

brands = {}
brand_data.each do |attrs|
  record = Brand.find_or_initialize_by(shop_id: shop.id, slug: attrs[:slug])
  is_new = record.new_record?
  record.assign_attributes(attrs.slice(:name, :description, :logo_url, :website_url, :instagram_url))
  record.shop_id = shop.id
  if record.save
    created_brands += 1 if is_new
    brands[attrs[:slug]] = record
    puts "  #{is_new ? 'CREATED' : 'EXISTS '} brand: #{record.name}"
  else
    puts "  ERROR   brand: #{attrs[:name]} — #{record.errors.full_messages.join(', ')}"
  end
end

puts ""

# ─────────────────── COLLECTIONS ───────────────────

collection_data = [
  { name: "Flower",       slug: "flower",       position: 1, description: "Premium indoor and outdoor flower from California's top cultivators." },
  { name: "Vapes",        slug: "vapes",        position: 2, description: "Cartridges and pods in live resin, distillate, and full-spectrum formats." },
  { name: "Edibles",      slug: "edibles",      position: 3, description: "Gummies, chocolates, mints, and more. Precisely dosed for a consistent experience." },
  { name: "Pre-Rolls",    slug: "pre-rolls",    position: 4, description: "Ready-to-smoke singles and packs, rolled with premium flower." },
  { name: "Concentrates", slug: "concentrates", position: 5, description: "Live resin, rosin, wax, and diamonds for the connoisseur." }
]

collections = {}
collection_data.each do |attrs|
  record = Collection.find_or_initialize_by(shop_id: shop.id, slug: attrs[:slug], parent_id: nil)
  is_new = record.new_record?
  record.assign_attributes(
    name:            attrs[:name],
    description:     attrs[:description],
    position:        attrs[:position],
    collection_type: "category",
    published:       true
  )
  record.shop_id = shop.id
  if record.save
    created_collections += 1 if is_new
    collections[attrs[:slug]] = record
    puts "  #{is_new ? 'CREATED' : 'EXISTS '} collection: #{record.name}"
  else
    puts "  ERROR   collection: #{attrs[:name]} — #{record.errors.full_messages.join(', ')}"
  end
end

puts ""

# ─────────────────── PRODUCTS ───────────────────
# Unsplash product-style images (royalty-free, no auth needed via direct photo IDs)
IMG = {
  flower:      "https://images.unsplash.com/photo-1616603983882-c3a56e96a7cc?w=600&q=80",
  vape:        "https://images.unsplash.com/photo-1585320806297-9794b3e4abb4?w=600&q=80",
  edible:      "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=80",
  pre_roll:    "https://images.unsplash.com/photo-1603909223429-69bb7101f420?w=600&q=80",
  concentrate: "https://images.unsplash.com/photo-1589396575653-c09c794ff6a6?w=600&q=80"
}.freeze

product_data = [
  # ── FLOWER (7 products) ──────────────────────────────────────
  {
    name: "Gary Payton",           slug: "gary-payton",
    product_type: "flower",        strain_name: "Gary Payton",
    strain_classification: "hybrid", brand: "cookies",
    price_cents: 5500,             weight: "3.5g",
    description: "Gary Payton is a potent hybrid named after the NBA Hall of Famer. Cookies' signature genetics deliver dense, trichome-loaded buds with notes of pepper, gas, and sweet cream. Expect a hard-hitting, euphoric high that smooths into full-body relaxation."
  },
  {
    name: "Blue Dream",            slug: "blue-dream",
    product_type: "flower",        strain_name: "Blue Dream",
    strain_classification: "sativa", brand: "cookies",
    price_cents: 4800,             weight: "3.5g",
    description: "Blue Dream is a sativa-dominant classic from the California coast. Sweet blueberry aroma from its Blueberry parent meets the cerebral invigoration of Haze. A gentle, creeping high makes it perfect for daytime creativity."
  },
  {
    name: "Wedding Cake",          slug: "wedding-cake",
    product_type: "flower",        strain_name: "Wedding Cake",
    strain_classification: "indica", brand: "cookies",
    price_cents: 5200,             weight: "3.5g",
    description: "Wedding Cake — also known as Pink Cookies — is a tangy, sweet indica-hybrid with rich undertones of earth and pepper. An exceptionally relaxing strain with a euphoric finish. Perfect for evenings when you want to decompress fully."
  },
  {
    name: "Runtz",                 slug: "runtz",
    product_type: "flower",        strain_name: "Runtz",
    strain_classification: "hybrid", brand: "cookies",
    price_cents: 6000,             weight: "3.5g",
    description: "Runtz is a rare and highly sought-after hybrid from Cookies. Its candy-sweet aroma and colorful, trichome-glazed buds have made it a staple of the top shelf. The high is long-lasting, euphoric, and supremely balanced."
  },
  {
    name: "Sherbet",               slug: "sherbet",
    product_type: "flower",        strain_name: "Sherbet",
    strain_classification: "indica", brand: "raw-garden",
    price_cents: 4500,             weight: "3.5g",
    description: "Sherbet delivers a complex bouquet of fruity, sweet, and earthy flavors. A deeply calming indica that grounds the body without completely locking you to the couch. Ideal for end-of-day unwinding."
  },
  {
    name: "Lemon Haze",            slug: "lemon-haze",
    product_type: "flower",        strain_name: "Lemon Haze",
    strain_classification: "sativa", brand: "raw-garden",
    price_cents: 4200,             weight: "3.5g",
    description: "Lemon Haze is a bright, citrus-forward sativa that delivers a clean, energizing high. Its tangy lemon aroma from Silver Haze and Lemon Skunk parentage carries through to a crisp, zesty smoke. Great for morning sessions."
  },
  {
    name: "Zkittlez",              slug: "zkittlez",
    product_type: "flower",        strain_name: "Zkittlez",
    strain_classification: "indica", brand: "cookies",
    price_cents: 5500,             weight: "3.5g",
    description: "Zkittlez packs a full spectrum of tropical, fruit-forward flavors in every hit. A powerful indica that starts with uplifting cerebral effects before settling into a warm, full-body calm. Multiple Cannabis Cup winner."
  },

  # ── VAPES (4 products) ──────────────────────────────────────
  {
    name: "Jack Herer Live Resin Pod",   slug: "jack-herer-live-resin-pod",
    product_type: "vape",                strain_name: "Jack Herer",
    strain_classification: "sativa",     brand: "stiiizy",
    price_cents: 4500,                   weight: "1g",
    description: "Stiiizy's Jack Herer live resin pod captures the classic spicy, pine-forward aroma of this legendary strain. The proprietary pod system delivers consistent, smooth vapor at any temperature. A smooth, energizing daytime vape."
  },
  {
    name: "Trainwreck Refined Live Resin", slug: "trainwreck-refined-live-resin",
    product_type: "vape",                  strain_name: "Trainwreck",
    strain_classification: "hybrid",       brand: "raw-garden",
    price_cents: 5500,                     weight: "1g",
    description: "Raw Garden's Trainwreck refined live resin preserves the full terpene profile of this potent hybrid. Expect a powerful, fast-acting high with notes of lemon, pine, and fresh wood. Certified Clean Cannabis."
  },
  {
    name: "Forbidden Fruit Cartridge",  slug: "forbidden-fruit-cartridge",
    product_type: "vape",               strain_name: "Forbidden Fruit",
    strain_classification: "indica",    brand: "select",
    price_cents: 4000,                  weight: ".5g",
    description: "Select's Forbidden Fruit cartridge delivers the cross of Cherry Pie and Tangie in a clean, reliable half-gram cart. Sweet tropical and cherry aromas lead into a deeply calming indica experience."
  },
  {
    name: "Strawberry Cough Live Resin", slug: "strawberry-cough-live-resin",
    product_type: "vape",                strain_name: "Strawberry Cough",
    strain_classification: "sativa",     brand: "stiiizy",
    price_cents: 4800,                   weight: "1g",
    description: "This Stiiizy live resin pod faithfully captures the sweet strawberry flavor Strawberry Cough is famous for. An uplifting, social sativa that eases anxiety while boosting mood and conversation."
  },

  # ── EDIBLES (4 products) ──────────────────────────────────────
  {
    name: "Watermelon Gummies",     slug: "watermelon-gummies",
    product_type: "edible",         strain_name: nil,
    strain_classification: nil,     brand: "wyld",
    price_cents: 2000,              weight: "100mg",
    description: "Wyld Watermelon Gummies are made with real watermelon and infused with broad-spectrum hemp-derived THC. Each gummy is precisely dosed at 10mg THC for a consistent, enjoyable experience. Vegan and gluten-free."
  },
  {
    name: "Dark Chocolate Bar",     slug: "dark-chocolate-bar",
    product_type: "edible",         strain_name: nil,
    strain_classification: nil,     brand: "kiva",
    price_cents: 2400,              weight: "100mg",
    description: "Kiva's Dark Chocolate Bar is crafted with 72% cacao and precisely dosed cannabis extract. Smooth, rich, and reliably consistent — each square delivers 5mg THC for easy micro-dosing. A classic for a reason."
  },
  {
    name: "Camino Sparkling Pear Gummies", slug: "camino-sparkling-pear-gummies",
    product_type: "edible",                strain_name: nil,
    strain_classification: nil,            brand: "kiva",
    price_cents: 2200,                     weight: "100mg",
    description: "Kiva's Camino Sparkling Pear gummies are terpene-enhanced for a 'buzzed + energetic' effect profile. Each 5mg gummy combines THC with sparkling pear flavor and uplifting terpenes for a bright, sociable high."
  },
  {
    name: "Huckleberry Gummies",    slug: "huckleberry-gummies",
    product_type: "edible",         strain_name: nil,
    strain_classification: nil,     brand: "wyld",
    price_cents: 2000,              weight: "100mg",
    description: "Inspired by the huckleberry patches of the Pacific Northwest, Wyld Huckleberry Gummies balance a perfect 1:1 THC:CBD ratio. Earthy, sweet, and gently calming — ideal for those seeking a mellow, balanced experience."
  },

  # ── PRE-ROLLS (3 products) ──────────────────────────────────────
  {
    name: "OG Kush Pre-Roll 5-Pack", slug: "og-kush-pre-roll-5-pack",
    product_type: "pre-roll",         strain_name: "OG Kush",
    strain_classification: "hybrid",  brand: "cookies",
    price_cents: 3500,                weight: "3.5g (5x.7g)",
    description: "Cookies' classic OG Kush rolled five-at-a-time. Earthy pine and sour lemon notes define this legendary hybrid. Each pre-roll is rolled with premium, single-origin OG Kush flower — no shake, no trim."
  },
  {
    name: "Sour Diesel Infused Pre-Roll", slug: "sour-diesel-infused-pre-roll",
    product_type: "pre-roll",              strain_name: "Sour Diesel",
    strain_classification: "sativa",       brand: "raw-garden",
    price_cents: 1800,                     weight: "1g",
    description: "Raw Garden's infused pre-roll takes premium Sour Diesel flower and adds a layer of their signature live resin concentrate for an elevated experience. Fast-acting, energizing, unmistakably diesel."
  },
  {
    name: "Granddaddy Purple Pre-Roll", slug: "granddaddy-purple-pre-roll",
    product_type: "pre-roll",             strain_name: "Granddaddy Purple",
    strain_classification: "indica",      brand: "select",
    price_cents: 1400,                    weight: ".7g",
    description: "A single, beautifully rolled GDP pre-roll from Select. Grape and berry aromas translate into a long-lasting, deeply relaxing indica experience. Perfect for an evening smoke."
  },

  # ── CONCENTRATES (2 products) ──────────────────────────────────────
  {
    name: "Papaya Punch Live Resin",  slug: "papaya-punch-live-resin",
    product_type: "concentrate",       strain_name: "Papaya Punch",
    strain_classification: "hybrid",   brand: "raw-garden",
    price_cents: 5800,                 weight: "1g",
    description: "Raw Garden's Papaya Punch live resin is extracted from certified clean, fresh-frozen Papaya Punch flower. Tropical and sweet with a smooth, creamy exhale. A premium sauce consistency that's ideal for a dab rig or e-rig."
  },
  {
    name: "Gelato Badder",            slug: "gelato-badder",
    product_type: "concentrate",       strain_name: "Gelato",
    strain_classification: "hybrid",   brand: "cookies",
    price_cents: 6500,                 weight: "1g",
    description: "Cookies Gelato Badder is crafted from the legendary Gelato strain — a cross of Sunset Sherbet and Thin Mint GSC. Sweet, dessert-forward flavors with a creamy, whipped consistency. Full-spectrum extract."
  }
]

# Map product_type to image key
IMG_KEY = {
  "flower"      => :flower,
  "vape"        => :vape,
  "edible"      => :edible,
  "pre-roll"    => :pre_roll,
  "concentrate" => :concentrate
}.freeze

product_data.each do |attrs|
  brand = brands[attrs[:brand]]
  unless brand
    puts "  SKIP    product: #{attrs[:name]} — brand '#{attrs[:brand]}' not found"
    next
  end

  record = Product.find_or_initialize_by(shop_id: shop.id, slug: attrs[:slug])
  is_new = record.new_record?

  record.assign_attributes(
    name:                   attrs[:name],
    product_type:           attrs[:product_type],
    strain_name:            attrs[:strain_name],
    strain_classification:  attrs[:strain_classification],
    brand_id:               brand.id,
    price_cents:            attrs[:price_cents],
    weight:                 attrs[:weight],
    description:            attrs[:description],
    image_url:              IMG[IMG_KEY[attrs[:product_type]]],
    published:              true
  )
  record.shop_id = shop.id

  if record.save
    created_products += 1 if is_new
    puts "  #{is_new ? 'CREATED' : 'EXISTS '} product: #{record.name} (#{record.product_type}, #{record.brand.name})"
  else
    puts "  ERROR   product: #{attrs[:name]} — #{record.errors.full_messages.join(', ')}"
  end
end

# ─────────────────── SUMMARY ───────────────────

puts "\n#{'='*50}"
puts "  Brands created:       #{created_brands}"
puts "  Collections created:  #{created_collections}"
puts "  Products created:     #{created_products}"
puts "  Total brands:         #{Brand.where(shop_id: shop.id).count}"
puts "  Total collections:    #{Collection.where(shop_id: shop.id).count}"
puts "  Total products:       #{Product.where(shop_id: shop.id, published: true).count}"
puts "#{'='*50}\n\n"
