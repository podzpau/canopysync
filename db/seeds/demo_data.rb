shop = Shop.first
abort "No shop found — run base seeds first" unless shop

PLACEHOLDER = "https://placehold.co/400x400/f5f5f1/1a1a17?text=Product"

# ---------------------------------------------------------------------------
# Brands
# ---------------------------------------------------------------------------
brands_data = [
  {
    name: "Cookies",
    slug: "cookies",
    description: "Founded by rapper Berner and grower Jai, Cookies is one of the most recognized cannabis brands in the world. Known for genetics like Girl Scout Cookies and Gelato, the brand blends streetwear culture with premium California cannabis."
  },
  {
    name: "Stiiizy",
    slug: "stiiizy",
    description: "Stiiizy pioneered the pod-based vape system and became a dominant force in California cannabis. Their proprietary hardware and premium oil formulations have made them the top-selling vape brand in the state."
  },
  {
    name: "Raw Garden",
    slug: "raw-garden",
    description: "Raw Garden specializes in single-source, live resin extracts made entirely from sun-grown California cannabis. Their farm-to-cartridge philosophy and commitment to terpene preservation set the standard for quality concentrates."
  },
  {
    name: "Kiva",
    slug: "kiva",
    description: "Kiva Confections makes award-winning cannabis edibles including chocolate bars, Petra mints, and Terra bites. Precise dosing and gourmet ingredients have made Kiva the most trusted edibles brand for both new and experienced consumers."
  },
  {
    name: "Select",
    slug: "select",
    description: "Select is one of the largest multi-state cannabis operators with a focus on clean, refined oil. Their Elite and Squeeze product lines are known for consistent potency and reliable performance across vape formats."
  },
  {
    name: "Wyld",
    slug: "wyld",
    description: "Wyld produces real fruit-based cannabis gummies in 10mg doses per piece. Each flavor corresponds to a strain type — Huckleberry for indica, Raspberry for hybrid, Pear for sativa — making dosing intuitive and enjoyable."
  }
]

brands = {}
brands_data.each do |attrs|
  brand = Brand.find_or_create_by!(slug: attrs[:slug], shop_id: shop.id) do |b|
    b.name        = attrs[:name]
    b.description = attrs[:description]
  end
  brands[attrs[:slug]] = brand
end

puts "Seeded #{brands.size} brands."

# ---------------------------------------------------------------------------
# Collections
# ---------------------------------------------------------------------------
collections_data = [
  {
    name: "Flower",
    slug: "flower",
    collection_type: "product_type",
    description: "Premium cannabis flower from top cultivators. Browse our curated selection of sativas, indicas, and hybrids — from classics like Blue Dream to exotic cuts like Runtz."
  },
  {
    name: "Vapes",
    slug: "vapes",
    collection_type: "product_type",
    description: "Convenient, discreet, and potent. Our vape selection includes 510-thread cartridges, all-in-one disposables, and pod systems from the most trusted brands in California."
  },
  {
    name: "Edibles",
    slug: "edibles",
    collection_type: "product_type",
    description: "A delicious way to experience cannabis. From Kiva chocolate bars to Wyld gummies, our edibles are precisely dosed and made with quality ingredients for a consistent experience."
  },
  {
    name: "Pre-Rolls",
    slug: "pre-rolls",
    collection_type: "product_type",
    description: "Ready to spark. Our pre-roll menu includes single joints, infused blunts, and multi-packs from top California brands. Perfect for on-the-go consumption."
  },
  {
    name: "Concentrates",
    slug: "concentrates",
    collection_type: "product_type",
    description: "Potent extracts for experienced consumers. Shop live resin, badder, sugar, and diamonds from award-winning extraction houses including Raw Garden and more."
  }
]

collections = {}
collections_data.each do |attrs|
  collection = Collection.find_or_create_by!(slug: attrs[:slug], shop_id: shop.id) do |c|
    c.name            = attrs[:name]
    c.collection_type = attrs[:collection_type]
    c.description     = attrs[:description]
    c.published       = true
    c.position        = collections_data.index(attrs)
  end
  collections[attrs[:slug]] = collection
end

puts "Seeded #{collections.size} collections."

# ---------------------------------------------------------------------------
# Products
# ---------------------------------------------------------------------------
products_data = [
  # Flower
  {
    name: "Gary Payton",
    product_type: "flower",
    strain_classification: "hybrid",
    price_cents: 5500,
    brand_slug: "cookies",
    collection_slug: "flower"
  },
  {
    name: "Blue Dream",
    product_type: "flower",
    strain_classification: "sativa",
    price_cents: 4500,
    brand_slug: "cookies",
    collection_slug: "flower"
  },
  {
    name: "Wedding Cake",
    product_type: "flower",
    strain_classification: "indica",
    price_cents: 5000,
    brand_slug: "cookies",
    collection_slug: "flower"
  },
  {
    name: "Gelato 41",
    product_type: "flower",
    strain_classification: "hybrid",
    price_cents: 5500,
    brand_slug: "cookies",
    collection_slug: "flower"
  },
  {
    name: "Runtz",
    product_type: "flower",
    strain_classification: "hybrid",
    price_cents: 6000,
    brand_slug: "cookies",
    collection_slug: "flower"
  },
  # Vapes
  {
    name: "Watermelon Live Resin Pod",
    product_type: "vape",
    strain_classification: nil,
    price_cents: 4500,
    brand_slug: "stiiizy",
    collection_slug: "vapes"
  },
  {
    name: "Strawnana .5g Pod",
    product_type: "vape",
    strain_classification: "hybrid",
    price_cents: 3500,
    brand_slug: "stiiizy",
    collection_slug: "vapes"
  },
  {
    name: "Orange Creamsicle Cartridge",
    product_type: "vape",
    strain_classification: "sativa",
    price_cents: 4000,
    brand_slug: "raw-garden",
    collection_slug: "vapes"
  },
  {
    name: "Papaya Punch Live Resin Cartridge",
    product_type: "vape",
    strain_classification: "hybrid",
    price_cents: 4200,
    brand_slug: "raw-garden",
    collection_slug: "vapes"
  },
  {
    name: "Lemon Pound Cake Elite Cartridge",
    product_type: "vape",
    strain_classification: "hybrid",
    price_cents: 3800,
    brand_slug: "select",
    collection_slug: "vapes"
  },
  # Edibles
  {
    name: "Watermelon Gummies 100mg",
    product_type: "edible",
    strain_classification: nil,
    price_cents: 2200,
    brand_slug: "wyld",
    collection_slug: "edibles"
  },
  {
    name: "Raspberry Sativa Gummies 100mg",
    product_type: "edible",
    strain_classification: "sativa",
    price_cents: 2200,
    brand_slug: "wyld",
    collection_slug: "edibles"
  },
  {
    name: "Dark Chocolate Bar 100mg",
    product_type: "edible",
    strain_classification: nil,
    price_cents: 2800,
    brand_slug: "kiva",
    collection_slug: "edibles"
  },
  {
    name: "Midnight Blueberry Chocolate Bar 100mg",
    product_type: "edible",
    strain_classification: "indica",
    price_cents: 2800,
    brand_slug: "kiva",
    collection_slug: "edibles"
  },
  # Pre-Rolls
  {
    name: "OG Kush Pre-Roll .5g",
    product_type: "pre-roll",
    strain_classification: "indica",
    price_cents: 1200,
    brand_slug: "cookies",
    collection_slug: "pre-rolls"
  },
  {
    name: "Sour Diesel Pre-Roll .5g",
    product_type: "pre-roll",
    strain_classification: "sativa",
    price_cents: 1200,
    brand_slug: "cookies",
    collection_slug: "pre-rolls"
  },
  {
    name: "Infused Blunt — Gelato 1g",
    product_type: "pre-roll",
    strain_classification: "hybrid",
    price_cents: 2500,
    brand_slug: "cookies",
    collection_slug: "pre-rolls"
  },
  # Concentrates
  {
    name: "Papaya Punch Live Resin Badder",
    product_type: "concentrate",
    strain_classification: "hybrid",
    price_cents: 5500,
    brand_slug: "raw-garden",
    collection_slug: "concentrates"
  },
  {
    name: "Strawberry Cough Live Resin Sugar",
    product_type: "concentrate",
    strain_classification: "sativa",
    price_cents: 5000,
    brand_slug: "raw-garden",
    collection_slug: "concentrates"
  },
  {
    name: "Zkittlez Diamonds & Sauce",
    product_type: "concentrate",
    strain_classification: "indica",
    price_cents: 6500,
    brand_slug: "select",
    collection_slug: "concentrates"
  }
]

# SeoScorable#calculate_seo_score references columns not yet in schema — skip it
Product.skip_callback(:save, :before, :calculate_seo_score)

begin
  products_data.each do |attrs|
    slug  = attrs[:name].parameterize
    brand = brands[attrs[:brand_slug]]

    Product.find_or_create_by!(slug: slug, shop_id: shop.id) do |p|
      p.name                  = attrs[:name]
      p.product_type          = attrs[:product_type]
      p.strain_classification = attrs[:strain_classification]
      p.price_cents           = attrs[:price_cents]
      p.brand_id              = brand&.id
      p.image_url             = PLACEHOLDER
      p.published             = true
    end
  end
ensure
  Product.set_callback(:save, :before, :calculate_seo_score)
end

puts "Seeded #{products_data.size} products."
