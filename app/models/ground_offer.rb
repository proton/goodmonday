class GroundOffer
  include Mongoid::Document
	include Mongoid::Symbolize

	before_update{ @changed_attrs = changes.clone }
	after_update :update_offers_state

	belongs_to :ground
	belongs_to :offer

	symbolize :state, :in => [:accepted, :denied, :pending], :default => :pending

	field :shows, type: Integer, default: 0
	field :payments, type: Integer, default: 0
	field :epc, type: Float, default: 0.0

	def update_offers_state
		if @changed_attrs.has_key? :state
			#TODO: переписать
			puts @changed_attrs.inspect
			ground = self.ground
			#
			link_offer_exists = ground.accepted_rotator_offers_ids(self.offer_id)
			link_offer_exists = ground.denied_rotator_offers_ids(self.offer_id) unless link_offer_exists
			link_offer_exists = ground.pending_rotator_offers_ids(self.offer_id) unless link_offer_exists
			ground.add_link_offer(self.offer) if link_offer_exists
			#
			rotator_offer = ground.accepted_rotator_offers_ids(self.offer_id)
			rotator_offer = ground.denied_rotator_offers_ids(self.offer_id) unless rotator_offer
			rotator_offer = ground.pending_rotator_offers_ids(self.offer_id) unless rotator_offer
			ground.add_rotator_offer(self.offer) if rotator_offer
			#
			ground.save
		end
	end
end
