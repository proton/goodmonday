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
	field :moderated_path, type: String

	def accept(current_operator)
		state = :accepted
		self.state = state
		self.moderation_state_changes.build({:state => state, :reason => :checked, :operator => current_operator})
		self.accepted_fields.merge! self.changed_fields
		self.changed_fields.clear
		self.save
		moderated_object.update_attribute(:moderated_state, state)
	end

	def deny(current_operator)
		state = :denied
		self.state = state
		self.moderation_state_changes.build({:state => state, :reason => :checked, :operator => current_operator})
		self.save
		moderated_object.update_attribute(:moderated_state, state)
	end

	def moderated_object
		if self.moderated_path
			eval(self.moderated_path)
		else
			moderated
		end
	end
end