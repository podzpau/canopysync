class AddNoindexToSeoModels < ActiveRecord::Migration[8.0]
  def change
    add_column :products,    :noindex, :boolean, default: false, null: false
    add_column :brands,      :noindex, :boolean, default: false, null: false
    add_column :collections, :noindex, :boolean, default: false, null: false
  end
end
