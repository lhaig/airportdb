class Airport < ActiveRecord::Base
  attr_accessible :continent, :country_id, :elevation_ft, :gps_code, :home_link, :iata_code, :ident, :keywords, :latitude_deg, :local_code, :longitude_deg, :municipality, :name, :region_id, :scheduled_service, :type, :wikipedia_link
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :regions
end
