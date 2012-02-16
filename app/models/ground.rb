class Ground
  include Mongoid::Document
	belongs_to :webmaster

	field :url, type: String
end
