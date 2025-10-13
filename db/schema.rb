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

ActiveRecord::Schema[8.0].define(version: 2025_10_12_024942) do
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
    t.index ["domain"], name: "index_shops_on_domain", unique: true
  end
end
