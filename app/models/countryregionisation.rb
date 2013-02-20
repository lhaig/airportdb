class Countryregionisation < ActiveRecord::Base
  attr_accessible :country_id, :region_id
  belongs_to :country
  belongs_to :region
end
