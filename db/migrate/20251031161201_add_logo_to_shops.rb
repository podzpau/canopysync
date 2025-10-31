class AddLogoToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :logo_url, :string
    add_column :shops, :logo_alt_text, :string
  end
end
