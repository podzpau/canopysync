class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.references :parent, null: true, foreign_key: { to_table: :collections }
      t.string :collection_type, null: false
      t.text :description
      t.integer :position, default: 0, null: false
      t.boolean :published, default: true, null: false

      t.timestamps
    end

    add_index :collections, [ :shop_id, :slug, :parent_id ], unique: true
    add_index :collections, [ :shop_id, :parent_id ]
  end
end
