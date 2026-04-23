class CreateRedirects < ActiveRecord::Migration[8.0]
  def change
    create_table :redirects do |t|
      t.references :shop, null: false, foreign_key: true
      t.string  :source_path,   null: false
      t.string  :target_path,   null: false
      t.integer :redirect_type, null: false, default: 301
      t.integer :hits,          null: false, default: 0
      t.boolean :active,        null: false, default: true

      t.timestamps
    end

    add_index :redirects, [ :shop_id, :source_path ], unique: true
  end
end
