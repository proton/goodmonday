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
			# "state"=>[:pending, :accepted]
			ground = self.ground
			ground.add_link_offer(self.offer) if ground.remove_link_offer(self.offer)
			ground.add_rotator_offer(self.offer) if ground.remove_rotator_offer(self.offer)
			ground.save
		end
	end
end
