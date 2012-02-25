class Advert
  include Mongoid::Document
	embedded_in :offer

	field :url, type: String
end
