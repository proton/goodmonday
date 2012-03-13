class Advert
  include Mongoid::Document

	before_save :update_offer_adverts_sizes

	embedded_in :offer

	field :sizes, type: Array, default: []

	scope :for_size, ->(size) { any_in(:sizes => [size]) }

	def update_offer_adverts_sizes
		self.offer.update_adverts_sizes
	end

	def self.html_code(size)
		"<img src='http://placehold.it/#{size}' />"
	end

	def html_code(size)
		Advert.html_code(size)
	end
end
