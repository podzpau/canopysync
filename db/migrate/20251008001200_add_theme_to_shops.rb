class AddThemeToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :font_family, :string, default: 'Inter'
    add_column :shops, :custom_font_url, :string
  end
end
