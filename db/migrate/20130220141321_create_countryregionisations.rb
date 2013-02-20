class CreateCountryregionisations < ActiveRecord::Migration
  def change
    create_table :countryregionisations do |t|
      t.integer :country_id
      t.integer :region_id

      t.timestamps
    end
  end
end
