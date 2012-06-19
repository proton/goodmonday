class Category
  include Mongoid::Document

	has_many :grounds
	has_many :offers

	field :title, type: String

  default_scope asc(:title)
end
