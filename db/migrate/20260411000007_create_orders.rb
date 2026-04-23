class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :meadow_id
      t.string :customer_name
      t.string :status, null: false, default: "completed"
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :tax_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.integer :item_count, null: false, default: 0
      t.datetime :ordered_at, null: false
      t.datetime :synced_at

      t.timestamps
    end

    add_index :orders, [ :shop_id, :ordered_at ]
    add_index :orders, [ :shop_id, :meadow_id ], unique: true, where: "meadow_id IS NOT NULL"
    add_index :orders, [ :shop_id, :status ]
  end
end
