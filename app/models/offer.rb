class Offer
	include Mongoid::Document

	belongs_to :advertiser
	#field :advertiser_id, type: Fields::Serializable::ForeignKeys::Object, default: lambda{current_user.id}
	embeds_many :targets
	embeds_many :adverts #TODO: подумать над автообъявлениями (к примеру на основе яндекс.маркета)
	field :adverts_sizes, type: Array, default: []
	has_and_belongs_to_many :grounds
	has_many :achievements

	field :title, type: String
	field :shows, type: Integer, default: 0
	field :payments, type: Integer, default: 0
	field :epc, type: Float, default: 0.0

	field :is_adult, type: Boolean, default: false
	field :is_doubtful, type: Boolean, default: false

	scope :for_advert_size, ->(size) { any_in(:adverts_sizes => size).order_by(:epc, :desc) }

	#TODO: добавить возможность неавтопроверки (а через сайт рекламодателя)

	def update_adverts_sizes
		self.adverts_sizes = self.adverts.collect{|a| a.sizes}.flatten.compact
		self.save
	end
end
