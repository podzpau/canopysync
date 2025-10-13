class AddSeoAndStyleToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :meta_title, :string
    add_column :shops, :meta_description, :text
    add_column :shops, :corner_style, :string
  end
end
