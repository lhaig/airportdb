class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string  :code
      t.string  :name
      t.string  :continent
      t.string  :wikipedia_link
      t.string  :keywords
      t.integer :airport_id
      t.integer :region_id

      t.timestamps
    end
  end
end
