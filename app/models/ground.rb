# coding: utf-8

class Ground
  include Mongoid::Document
	include Mongoid::Symbolize

	before_create :build_ground_rotator_config

	belongs_to :webmaster
	#field :webmaster_id, type: Fields::Serializable::ForeignKeys::Object, default: -> {current_user.id}
	belongs_to :category

	field :title, type: String, default: ''
	field :url, type: String, default: ''

  auto_increment :alternative_id
  index({alternative_id: 1 }, { unique: true })

	symbolize :type, :in => [:website, :doorway, :socialnet, :context, :email, :etc], :default => :website

	symbolize :rotator_mode, :in => [:manual, :auto], :default => :manual
	embeds_one :ground_rotator_config
	accepts_nested_attributes_for :ground_rotator_config

	field :accepted_rotator_offers_ids, type: Array, default: []
	field :denied_rotator_offers_ids, type: Array, default: []
	field :pending_rotator_offers_ids, type: Array, default: []
	field :accepted_link_offers_ids, type: Array, default: []
	field :denied_link_offers_ids, type: Array, default: []
	field :pending_link_offers_ids, type: Array, default: []

	def advert_offers_ids
    self.accepted_rotator_offers_ids+self.denied_rotator_offers_ids+self.pending_rotator_offers_ids
  end
	def advert_offers
    Offer.any_in(_id: advert_offers_ids)
  end
	def link_offers_ids
    self.accepted_link_offers_ids+self.denied_link_offers_ids+self.pending_link_offers_ids
  end
  def link_offers
    Offer.any_in(_id: link_offers_ids)
  end

	def find_offer_permission(offer_id)
		self.ground_offers.where(:offer_id => offer_id).first
	end

	def find_or_create_offer_permission(offer)
		ground_offer = find_offer_permission offer.id
		unless ground_offer
			ground_offer = self.ground_offers.new
			if offer.auto_accept_grounds
        if offer.excepted_categories.exclude?(self.category_id)
          if offer.excepted_ground_types.exclude?(self.type)
            ground_offer.state=:accepted
          end
        end
      end
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
		offer_id = (offer.is_a? Offer) ? offer.id : offer
		link_offer = self.accepted_link_offers_ids.delete(offer_id)
		if link_offer
			offer = Offer.find(offer_id) unless (offer.is_a? Offer)
			UserMailer.link_offer_removing(self.webmaster, offer).deliver
		else
			link_offer = self.denied_link_offers_ids.delete(offer_id)
			link_offer = self.pending_link_offers_ids.delete(offer_id) unless link_offer
		end
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
		offer_id = (offer.class==Offer)? offer.id : offer
		rotator_offer = self.accepted_rotator_offers_ids.delete(offer_id)
		rotator_offer = self.denied_rotator_offers_ids.delete(offer_id) unless rotator_offer
		rotator_offer = self.pending_rotator_offers_ids.delete(offer_id) unless rotator_offer
		rotator_offer
	end

	def remove_rotator_offer_and_save(offer)
		self.remove_rotator_offer(offer)
		self.save
	end

	def remove_all_rotator_offers
		self.accepted_rotator_offers_ids.clear
		self.denied_rotator_offers_ids.clear
		self.pending_rotator_offers_ids.clear
	end


	has_many :ground_offers, dependent: :delete

	has_many :achievements

	def accepted_offers
		offers = case self.rotator_mode
			when :manual
				Offer.any_in(_id: self.accepted_rotator_offers_ids)
			when :auto
				self.ground_rotator_config.offers
      else
        Offer.all
			end
		offers.accepted
	end

	def change_webmaster!(new_webmaster)
		old_webmaster_id = self.webmaster_id
		self.webmaster = new_webmaster
		self.save!
		StatCounter.where(:ground_id => self.id, :webmaster_id => old_webmaster_id).update(webmaster_id: new_webmaster.id)
    self.achievements.update(webmaster_id: new_webmaster.id)
	end

	#validates :url, :uniqueness => true

	MODERATED_ATTRS = %w[title url type category_id]
	include IsModerated

end
