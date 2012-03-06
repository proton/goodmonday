class Ground
  include Mongoid::Document
	include Mongoid::Symbolize

	belongs_to :webmaster
	#field :webmaster_id, type: Fields::Serializable::ForeignKeys::Object, default: -> {current_user.id}

	symbolize :mode, :in => [:manual, :automatic], :default => :manual
	#if manual:
		has_and_belongs_to_many :offers
		#вот тут нужна возможность работы с конкретным оффером
	#if automatic:
		field :block_adult, type: Boolean, default: true
		field :block_doubtful, type: Boolean, default: true

	has_many :achievements

	def accepted_offers
		case self.mode
			when :manual
				return self.offers
			when :automatic
				return Offer.where(:is_adult => !self.block_adult).where(:is_doubtful => !self.block_doubtful)
		end
	end

	field :url, type: String

	#validates :url, :uniqueness => true
end
