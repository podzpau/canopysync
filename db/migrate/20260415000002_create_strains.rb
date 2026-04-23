class CreateStrains < ActiveRecord::Migration[8.0]
  def change
    create_table :strains do |t|
      t.bigint  :shop_id,        null: false
      t.string  :name,           null: false
      t.string  :slug,           null: false
      t.string  :classification
      t.text    :description
      t.string  :seo_title
      t.text    :seo_description
      t.boolean :noindex,        null: false, default: false

      t.timestamps
    end

    add_index :strains, :shop_id
    add_index :strains, [ :shop_id, :slug ], unique: true
    add_foreign_key :strains, :shops
  end
end
