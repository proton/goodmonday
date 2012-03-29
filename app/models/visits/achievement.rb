class Achievement
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Symbolize

	symbolize :state, :in => [:pending, :accepted, :denied], :default => :pending, :scopes => true

	belongs_to :webmaster
	belongs_to :advertiser
	belongs_to :ground
	belongs_to :offer
	belongs_to :visitor
	field :target_id, type: BSON::ObjectId

	field :page, type: String
	field :ip, type: String

	field :price, type: Integer

	field :order_id, type: String #optional for manual confirmation

	def is_accepted?
		self.state==:accepted
	end
end
