class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :domain
      t.string :logo_url

      # Branding
      t.string :primary_color, default: "#10b981"
      t.string :secondary_color, default: "#059669"

      # Homepage content
      t.string :hero_title, default: "Premium Cannabis Delivered"
      t.text :hero_subtitle
      t.string :hero_image_url

      # Business info
      t.text :about_text
      t.string :phone
      t.string :email
      t.text :delivery_areas
      t.text :hours

      # Settings
      t.boolean :show_thc_levels, default: true
      t.boolean :require_age_verification, default: true
      t.integer :minimum_order_amount, default: 0

      # Template system
      t.integer :template, default: 0
      t.text :blocks_config

      # Integrations
      t.string :meadow_api_key
      t.string :meadow_location_id

      t.timestamps
    end

    add_index :shops, :domain, unique: true
  end
end
