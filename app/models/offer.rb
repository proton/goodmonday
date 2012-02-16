class Offer
  include Mongoid::Document
	belongs_to :advertiser
	embeds_many :targets
	embeds_many :adverts

	field :title, type: String
end
