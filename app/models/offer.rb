class Offer
	include Mongoid::Document
	belongs_to :advertiser
	#field :advertiser_id, type: Fields::Serializable::ForeignKeys::Object, default: lambda{current_user.id}
	embeds_many :targets
	embeds_many :adverts #TODO: подумать над автообъявлениями (к примеру на основе яндекс.маркета)
	has_and_belongs_to_many :grounds
	has_many :achievements

	field :title, type: String
	field :shows, type: Integer, default: 0
	field :payments, type: Integer, default: 0
	field :epc, type: Float, default: 0.0

	field :is_adult, type: Boolean, default: false
	field :is_doubtful, type: Boolean, default: false

	#TODO: добавить возможность неавтопроверки (а через сайт рекламодателя)
end
