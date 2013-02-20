class Country < ActiveRecord::Base
  attr_accessible :code, :continent, :keywords, :name, :wikipedia_link
  belongs_to :region
  has_many :airports
end
