class Advert
  include Mongoid::Document

  before_save :update_offer_adverts_sizes
	before_destroy :update_offer_adverts_sizes

	embedded_in :offer

	field :sizes, type: Array, default: []

	scope :for_size, ->(size) { any_in(:sizes => [size.to_sym]) }

	def update_offer_adverts_sizes
    puts 'advert.update_offer_adverts_sizes'
		self.offer.update_adverts_sizes
	end

	def self.html_code(size)
		"<a href='http://goodmonday.ru'><img src='http://placehold.it/#{size}' /></a>"
	end

	def html_code(size, ground)
		Advert.html_code(size)
	end
end
