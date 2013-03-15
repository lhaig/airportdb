class Region < ActiveRecord::Base
  attr_accessible :code, :continent, :country_id, :keywords, :local_code, :name, :wikipedia_link
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :airports
end
