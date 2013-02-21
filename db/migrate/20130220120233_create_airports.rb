class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :ident
      t.string :airport_type
      t.string :name
      t.string :latitude_deg
      t.string :longitude_deg
      t.string :elevation_ft
      t.integer :continent_id
      t.integer :country_id
      t.integer :region_id
      t.string :municipality
      t.string :scheduled_service
      t.string :gps_code
      t.string :iata_code
      t.string :local_code
      t.string :home_link
      t.string :wikipedia_link
      t.string :keywords

      t.timestamps
    end
  end
end
