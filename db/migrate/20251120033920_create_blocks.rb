class CreateBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :blocks do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :block_type
      t.integer :position
      t.json :content

      t.timestamps
    end
  end
end
