class CreateBrands < ActiveRecord::Migration[8.0]
  def change
    create_table :brands do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :logo_url
      t.string :website_url
      t.string :instagram_url
      t.string :twitter_url
      t.string :linkedin_url
      t.string :wikipedia_url
      t.string :wikidata_url
      t.string :meadow_id

      t.timestamps
    end

    add_index :brands, [ :shop_id, :slug ], unique: true
    add_index :brands, [ :shop_id, :meadow_id ], unique: true
  end
end
