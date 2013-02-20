class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :ident
      t.string :type
      t.string :name
      t.string :latitude_deg
      t.string :longitude_deg
      t.string :elevation_ft
      t.text :continent
      t.integer :country_id
      t.integer :region_id
      t.text :municipality
      t.text :scheduled_service
      t.text :gps_code
      t.text :iata_code
      t.text :local_code
      t.text :home_link
      t.text :wikipedia_link
      t.text :keywords

      t.timestamps
    end
  end
end
