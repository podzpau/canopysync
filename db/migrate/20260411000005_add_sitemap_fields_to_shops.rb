class AddSitemapFieldsToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :sitemap_updated_at, :datetime
    add_column :shops, :html_sitemap_enabled, :boolean, default: true, null: false
  end
end
