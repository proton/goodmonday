class Advert
  include Mongoid::Document

	before_save :update_offer_adverts_sizes

	embedded_in :offer

	field :sizes, type: Array, default: []

	def update_offer_adverts_sizes
		self.offer.update_adverts_sizes
	end
end
