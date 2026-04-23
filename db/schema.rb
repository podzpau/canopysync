# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_04_23_115249) do
  create_table "admin_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["shop_id"], name: "index_admin_users_on_shop_id"
  end


  create_table "blocks", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "block_type"
    t.integer "position"
    t.json "content", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "variant"
    t.index ["shop_id"], name: "index_blocks_on_shop_id"
  end

  create_table "brands", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "logo_url"
    t.string "website_url"
    t.string "instagram_url"
    t.string "twitter_url"
    t.string "linkedin_url"
    t.string "wikipedia_url"
    t.string "wikidata_url"
    t.string "meadow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "seo_title"
    t.text "seo_description"
    t.boolean "noindex", default: false, null: false
    t.index ["shop_id", "meadow_id"], name: "index_brands_on_shop_id_and_meadow_id", unique: true
    t.index ["shop_id", "slug"], name: "index_brands_on_shop_id_and_slug", unique: true
    t.index ["shop_id"], name: "index_brands_on_shop_id"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "parent_id"
    t.string "collection_type", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.boolean "published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "seo_title"
    t.text "seo_description"
    t.boolean "noindex", default: false, null: false
    t.index ["parent_id"], name: "index_collections_on_parent_id"
    t.index ["shop_id", "parent_id"], name: "index_collections_on_shop_id_and_parent_id"
    t.index ["shop_id", "slug", "parent_id"], name: "index_collections_on_shop_id_and_slug_and_parent_id", unique: true
    t.index ["shop_id"], name: "index_collections_on_shop_id"
  end

  create_table "concept_entities", force: :cascade do |t|
    t.string "key", null: false
    t.string "name", null: false
    t.string "wikipedia_url"
    t.string "wikidata_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_concept_entities_on_key", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id"
    t.string "product_name", null: false
    t.string "product_type"
    t.string "brand_name"
    t.integer "quantity", default: 1, null: false
    t.integer "unit_price_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["product_name"], name: "index_order_items_on_product_name"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "meadow_id"
    t.string "customer_name"
    t.string "status", default: "completed", null: false
    t.integer "subtotal_cents", default: 0, null: false
    t.integer "tax_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.integer "item_count", default: 0, null: false
    t.datetime "ordered_at", null: false
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "meadow_id"], name: "index_orders_on_shop_id_and_meadow_id", unique: true, where: "(meadow_id IS NOT NULL)"
    t.index ["shop_id", "ordered_at"], name: "index_orders_on_shop_id_and_ordered_at"
    t.index ["shop_id", "status"], name: "index_orders_on_shop_id_and_status"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "product_type", null: false
    t.string "strain_name"
    t.string "strain_classification"
    t.integer "brand_id"
    t.text "description"
    t.string "image_url"
    t.integer "price_cents"
    t.string "weight"
    t.boolean "published", default: true, null: false
    t.string "meadow_id"
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "seo_title"
    t.text "seo_description"
    t.boolean "noindex", default: false, null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["shop_id", "brand_id"], name: "index_products_on_shop_id_and_brand_id"
    t.index ["shop_id", "meadow_id"], name: "index_products_on_shop_id_and_meadow_id", unique: true
    t.index ["shop_id", "product_type"], name: "index_products_on_shop_id_and_product_type"
    t.index ["shop_id", "slug"], name: "index_products_on_shop_id_and_slug", unique: true
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "redirects", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "source_path", null: false
    t.string "target_path", null: false
    t.integer "redirect_type", default: 301, null: false
    t.integer "hits", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "source_path"], name: "index_redirects_on_shop_id_and_source_path", unique: true
    t.index ["shop_id"], name: "index_redirects_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "logo_url"
    t.string "hero_title", default: "Premium Cannabis Delivered"
    t.text "hero_subtitle"
    t.string "hero_image_url"
    t.text "about_text"
    t.string "phone"
    t.string "email"
    t.text "delivery_areas"
    t.text "hours"
    t.boolean "show_thc_levels", default: true
    t.boolean "require_age_verification", default: true
    t.integer "minimum_order_amount", default: 0
    t.integer "template", default: 0
    t.text "blocks_config"
    t.string "meadow_api_key"
    t.string "meadow_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "primary_color", default: "#10b981"
    t.string "secondary_color", default: "#3b82f6"
    t.string "font_family", default: "Inter"
    t.string "custom_font_url"
    t.string "meta_title"
    t.text "meta_description"
    t.string "corner_style"
    t.datetime "sitemap_updated_at"
    t.boolean "html_sitemap_enabled", default: true, null: false
    t.string "default_seo_title_suffix"
    t.string "google_analytics_id"
    t.string "google_search_console_verification"
    t.text "custom_robots_txt"
    t.text "published_blocks_config"
    t.string "published_primary_color"
    t.string "published_secondary_color"
    t.string "published_font_family"
    t.string "published_logo_url"
    t.datetime "published_at"
    t.index ["domain"], name: "index_shops_on_domain", unique: true
  end

  create_table "strains", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "classification"
    t.text "description"
    t.string "seo_title"
    t.text "seo_description"
    t.boolean "noindex", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "slug"], name: "index_strains_on_shop_id_and_slug", unique: true
    t.index ["shop_id"], name: "index_strains_on_shop_id"
  end

  add_foreign_key "admin_users", "shops"
  add_foreign_key "blocks", "shops"
  add_foreign_key "brands", "shops"
  add_foreign_key "collections", "collections", column: "parent_id"
  add_foreign_key "collections", "shops"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "shops"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "shops"
  add_foreign_key "redirects", "shops"
  add_foreign_key "strains", "shops"
end
