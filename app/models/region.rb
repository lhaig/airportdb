class Region < ActiveRecord::Base
  attr_accessible :code, :continent, :country_id, :keywords, :local_code, :name, :wikipedia_link
  has_many :countryregionisations
  has_many :countries, :through => :countryregionisations
end
