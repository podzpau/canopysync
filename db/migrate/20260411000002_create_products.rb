class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :product_type, null: false
      t.string :strain_name
      t.string :strain_classification
      t.references :brand, null: true, foreign_key: true
      t.text :description
      t.string :image_url
      t.integer :price_cents
      t.string :weight
      t.boolean :published, default: true, null: false
      t.string :meadow_id
      t.datetime :synced_at

      t.timestamps
    end

    add_index :products, [ :shop_id, :slug ], unique: true
    add_index :products, [ :shop_id, :product_type ]
    add_index :products, [ :shop_id, :brand_id ]
    add_index :products, [ :shop_id, :meadow_id ], unique: true
  end
end
