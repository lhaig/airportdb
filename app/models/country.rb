class Country < ActiveRecord::Base
  attr_accessible :code, :continent, :keywords, :name, :wikipedia_link
end