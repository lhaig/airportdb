class Country < ActiveRecord::Base
  attr_accessible :code, :continent, :keywords, :name, :wikipedia_link
  has_one :region
  has_and_belongs_to_many :airports
end
