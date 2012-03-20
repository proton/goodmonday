class Ground
  include Mongoid::Document
	include Mongoid::Symbolize

	belongs_to :webmaster
	#field :webmaster_id, type: Fields::Serializable::ForeignKeys::Object, default: -> {current_user.id}
	belongs_to :category

	field :title, type: String, default: ''
	field :url, type: String, default: ''

	symbolize :type, :in => [:website, :doorway, :socialnet], :default => :website

	symbolize :rotator_mode, :in => [:manual, :automatic], :default => :manual

	field :accepted_rotator_offers_ids, type: Array, default: []
	field :denied_rotator_offers_ids, type: Array, default: []
	field :pending_rotator_offers_ids, type: Array, default: []
	field :accepted_link_offers_ids, type: Array, default: []
	field :denied_link_offers_ids, type: Array, default: []
	field :pending_link_offers_ids, type: Array, default: []

	define_method(:advert_offers_ids) { self.accepted_rotator_offers_ids+self.denied_rotator_offers_ids+self.pending_rotator_offers_ids }
	define_method(:advert_offers) { Offer.find(advert_offers_ids) }
	define_method(:link_offers_ids) { self.accepted_link_offers_ids+self.denied_link_offers_ids+self.pending_link_offers_ids }
	define_method(:link_offers) { Offer.find(link_offers_ids) }

	def find_or_create_offer_permission(offer)
		ground_offer = self.ground_offers.where(:offer_id => offer.id).first
		unless ground_offer
			ground_offer = self.ground_offers.new
			ground_offer.state=:accepted if offer.auto_accept_grounds
			ground_offer.offer = offer
			ground_offer.save
		end
		ground_offer
	end

	def add_link_offer(offer)
		ground_offer = find_or_create_offer_permission(offer)
		case ground_offer.state
			when :accepted
				self.accepted_link_offers_ids << offer.id
			when :denied
				self.denied_link_offers_ids << offer.id
			when :pending
				self.pending_link_offers_ids << offer.id
		end
	end

	def add_link_offer_and_save(offer)
		self.add_link_offer(offer)
		self.save
	end

	def remove_link_offer(offer)
		link_offer = self.accepted_link_offers_ids.delete(offer.id)
		link_offer = self.denied_link_offers_ids.delete(offer.id) unless link_offer
		link_offer = self.pending_link_offers_ids.delete(offer.id) unless link_offer
		link_offer
	end

	def remove_link_offer_and_save(offer)
		remove_link_offer(offer)
		self.save
	end

	def add_rotator_offer(offer)
		ground_offer = find_or_create_offer_permission(offer)
		case ground_offer.state
			when :accepted
				self.accepted_rotator_offers_ids << offer.id
			when :denied
				self.denied_rotator_offers_ids << offer.id
			when :pending
				self.pending_rotator_offers_ids << offer.id
		end
	end

	def add_rotator_offer_and_save(offer)
		self.add_rotator_offer(offer)
		self.save
	end

	def remove_rotator_offer(offer)
		rotator_offer = self.accepted_rotator_offers_ids.delete(offer.id)
		rotator_offer = self.denied_rotator_offers_ids.delete(offer.id) unless rotator_offer
		rotator_offer = self.pending_rotator_offers_ids.delete(offer.id) unless rotator_offer
		rotator_offer
	end

	def remove_rotator_offer_and_save(offer)
		self.remove_rotator_offer(offer)
		self.save
	end

	# Offer.any_in(_id: ['4f4cfb35852488182000004b','4f508b3e8524887254000061','4f4a4c2385248837ff000004'])

	has_many :ground_offers

	#if automatic:
	field :block_adult, type: Boolean, default: true
	field :block_doubtful, type: Boolean, default: true

	has_many :achievements

	#def accepted_offers
	#	case self.mode
	#		when :manual
	#			return self.offers
	#		when :automatic
	#			return Offer.where(:is_adult => !self.block_adult).where(:is_doubtful => !self.block_doubtful)
	#	end
	#end

	#validates :url, :uniqueness => true

	MODERATED_ATTRS = [:title, :url, :type, :category_id]
	include IsModerated

end
