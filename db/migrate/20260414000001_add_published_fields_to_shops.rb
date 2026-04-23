class AddPublishedFieldsToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :published_blocks_config, :text
    add_column :shops, :published_primary_color, :string
    add_column :shops, :published_secondary_color, :string
    add_column :shops, :published_font_family, :string
    add_column :shops, :published_logo_url, :string
    add_column :shops, :published_at, :datetime
  end
end
