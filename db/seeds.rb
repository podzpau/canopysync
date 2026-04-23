concept_entities = [
  { key: "cannabis_edible",     name: "Cannabis Edible",     wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_edible" },
  { key: "cannabis_concentrate", name: "Cannabis Concentrate", wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_concentrate" },
  { key: "joint",               name: "Joint",               wikipedia_url: "https://en.wikipedia.org/wiki/Joint_(cannabis)" },
  { key: "tincture_of_cannabis", name: "Tincture of Cannabis", wikipedia_url: "https://en.wikipedia.org/wiki/Tincture_of_cannabis" },
  { key: "kief",                name: "Kief",                wikipedia_url: "https://en.wikipedia.org/wiki/Kief" },
  { key: "hash_oil",            name: "Hash Oil",            wikipedia_url: "https://en.wikipedia.org/wiki/Hash_oil" },
  { key: "blunt",               name: "Blunt",               wikipedia_url: "https://en.wikipedia.org/wiki/Blunt_(cannabis)" },
  { key: "hashish",             name: "Hashish",             wikipedia_url: "https://en.wikipedia.org/wiki/Hashish" },
  { key: "chillum",             name: "Chillum",             wikipedia_url: "https://en.wikipedia.org/wiki/Chillum_(pipe)" },
  { key: "herb_grinder",        name: "Herb Grinder",        wikipedia_url: "https://en.wikipedia.org/wiki/Herb_grinder" },
  { key: "cannabis_sativa",     name: "Cannabis Sativa",     wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_sativa" },
  { key: "cannabis_indica",     name: "Cannabis Indica",     wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_indica" },
  { key: "cannabis_flower",     name: "Cannabis Flower",     wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_(drug)" },
  { key: "pre_roll",            name: "Pre-Roll",            wikipedia_url: "https://en.wikipedia.org/wiki/Joint_(cannabis)" },
  { key: "vape_cartridge",      name: "Vape Cartridge",      wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_vaporizer" },
  { key: "cannabis",            name: "Cannabis",            wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis_(drug)" }
]

concept_entities.each do |attrs|
  ConceptEntity.find_or_create_by!(key: attrs[:key]) do |e|
    e.name = attrs[:name]
    e.wikipedia_url = attrs[:wikipedia_url]
  end
end

shop = Shop.find_or_create_by!(domain: "localhost") do |s|
  s.name = "Default Shop"
end

AdminUser.find_or_create_by!(email: "admin@canopysync.com") do |admin|
  admin.password = "changeme123"
  admin.shop_id = shop.id
end

puts "⚠️  Change the default admin password immediately!"

# ---------------------------------------------------------------------------
# Sample order data — 90 days of realistic POS sales for dashboard previews
# ---------------------------------------------------------------------------
if Order.where(shop: shop).none?
  product_types = %w[flower flower flower pre-roll edible concentrate vape tincture topical]
  brand_names   = [ "STIIIZY", "Raw Garden", "Kiva", "Pax", "Select",
                    "Cookies", "Jeeter", "Heavy Hitters", "Wyld", "Camino" ]
  strain_names  = [ "Blue Dream", "OG Kush", "Girl Scout Cookies", "Gelato",
                    "Wedding Cake", "Jack Herer", "Sour Diesel", "Purple Punch",
                    "Zkittlez", "Gorilla Glue" ]

  90.times do |days_ago|
    date = days_ago.days.ago
    rand(5..25).times do
      order = shop.orders.create!(
        status: "completed",
        ordered_at: date + rand(8..22).hours + rand(60).minutes,
        item_count: rand(1..6),
        subtotal_cents: 0,
        tax_cents: 0,
        total_cents: 0
      )

      order.item_count.times do
        product_type = product_types.sample
        unit_price   = case product_type
                       when "flower"      then rand(25..65) * 100
                       when "pre-roll"    then rand(8..20) * 100
                       when "edible"      then rand(15..40) * 100
                       when "concentrate" then rand(30..80) * 100
                       when "vape"        then rand(25..60) * 100
                       when "tincture"    then rand(20..50) * 100
                       when "topical"     then rand(15..45) * 100
                       else                    rand(20..50) * 100
                       end
        quantity = rand(1..3)

        order.order_items.create!(
          product_name:     "#{strain_names.sample} #{product_type.titleize}",
          product_type:     product_type,
          brand_name:       brand_names.sample,
          quantity:         quantity,
          unit_price_cents: unit_price,
          total_cents:      unit_price * quantity
        )
      end

      subtotal = order.order_items.sum(:total_cents)
      tax      = (subtotal * 0.0925).round
      order.update!(subtotal_cents: subtotal, tax_cents: tax, total_cents: subtotal + tax)
    end
  end

  puts "Seeded 90 days of sample orders for #{shop.name}."
end

load Rails.root.join('db/seeds/demo_data.rb')
