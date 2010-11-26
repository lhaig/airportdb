class CreateAirports < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.string :iatacode
      t.string :name
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end

  def self.down
    drop_table :airports
  end
end
