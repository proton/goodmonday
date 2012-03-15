class Category
  include Mongoid::Document

	has_many :grounds
	has_many :offers

	field :title, type: String
end
