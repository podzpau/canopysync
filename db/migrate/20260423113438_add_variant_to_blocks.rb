class AddVariantToBlocks < ActiveRecord::Migration[8.0]
  def change
    add_column :blocks, :variant, :string
  end
end
