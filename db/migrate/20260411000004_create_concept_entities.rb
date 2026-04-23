class CreateConceptEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :concept_entities do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.string :wikipedia_url
      t.string :wikidata_url

      t.timestamps
    end

    add_index :concept_entities, :key, unique: true
  end
end
