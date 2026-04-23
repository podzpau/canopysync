class AddSeoFieldsToBrandsAndCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :brands, :seo_title, :string
    add_column :brands, :seo_description, :text

    add_column :collections, :seo_title, :string
    add_column :collections, :seo_description, :text
  end
end
