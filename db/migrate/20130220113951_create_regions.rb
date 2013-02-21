class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :code
      t.string :local_code
      t.string :name
      t.integer :continent_id
      t.integer :country_id
      t.string :wikipedia_link
      t.string :keywords

      t.timestamps
    end
  end
end
