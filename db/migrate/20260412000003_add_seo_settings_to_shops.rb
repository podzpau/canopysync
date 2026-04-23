class AddSeoSettingsToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :default_seo_title_suffix, :string
    add_column :shops, :google_analytics_id, :string
    add_column :shops, :google_search_console_verification, :string
    add_column :shops, :custom_robots_txt, :text
  end
end
