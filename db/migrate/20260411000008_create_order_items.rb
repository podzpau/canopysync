class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: true, foreign_key: true
      t.string :product_name, null: false
      t.string :product_type
      t.string :brand_name
      t.integer :quantity, null: false, default: 1
      t.integer :unit_price_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0

      t.timestamps
    end

    add_index :order_items, :product_name
  end
end
