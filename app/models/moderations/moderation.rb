class Moderation
	include Mongoid::Document
	include Mongoid::Symbolize
	include Mongoid::Timestamps

	#before_create :add_initial_state_change

	belongs_to :moderated, polymorphic: true
	embeds_many :moderation_field_changes
	embeds_many :moderation_state_changes

	symbolize :state, :in => [:accepted, :denied, :pending], :default => :pending
	symbolize :reason, :in => [:created, :updated], :default => :created
	field :moderated_type, type: String, default: -> { self.moderated.class.to_s }
	field :changed_fields, type: Hash, default: {}
	field :accepted_fields, type: Hash, default: {}

	def accept
		self.state = :accepted
		self.moderated.moderated_state = self.state
		self.accepted_fields.merge! self.changed_fields
		self.changed_fields.clear
		self.moderation_state_changes.build({:state => self.state, :reason => :checked})
		self.moderated.save
		self.save
	end

	def deny
		self.state = :denied
		self.moderation_state_changes.build({:state => self.state, :reason => :checked})
		self.moderated.moderated_state = self.state
		self.moderated.save
		self.save
	end
end