class GroundOffer
  include Mongoid::Document
	include Mongoid::Symbolize
  include Mongoid::MoneyField

	before_update{ @changed_attrs = changes.clone }
	after_update :update_offers_state
	after_destroy :destroy_offers_in_ground

	belongs_to :ground
	belongs_to :offer

	symbolize :state, :in => [:accepted, :denied, :pending], :default => :pending

	field :clicks, type: Integer, default: 0
  money_field :payments
	money_field :epc

	def update_offers_state
		if @changed_attrs.has_key? :state
			#TODO: переписать
			# "state"=>[:pending, :accepted]
			ground = self.ground
			ground.add_link_offer(self.offer) if ground.remove_link_offer(self.offer)
			ground.add_rotator_offer(self.offer) if ground.remove_rotator_offer(self.offer)
			ground.save
		end
	end

	def destroy_offers_in_ground
		ground = self.ground
		if ground
			ground.remove_rotator_offer self.offer_id
			ground.remove_link_offer self.offer_id
		end
	end

end
