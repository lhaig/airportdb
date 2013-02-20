class Region < ActiveRecord::Base
  attr_accessible :code, :continent, :iso_country, :keywords, :local_code, :name, :wikipedia_link
end
