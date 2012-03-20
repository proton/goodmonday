module IsModerated
	extend ActiveSupport::Concern

	included do
		has_one :moderation, as: :moderated
		field :moderated_state, type: Symbol, default: :pending
		scope :moderated, where(:moderated_state => :accepted)
		after_create :add_moderation
		before_update{ @changed_attrs = changes.clone }
		after_update :set_moderation
	end

	def self.moderated_fields
		self.class::MODERATED_ATTRS
	end

	def add_moderation
		moderated_fields = self.class::MODERATED_ATTRS
		change_moderation moderated_fields, :created
	end

	def set_moderation
		moderated_fields = @changed_attrs.keys & self.class::MODERATED_ATTRS
		change_moderation moderated_fields, :updated
	end

	def change_moderation(moderated_fields, reason)
		return if moderated_fields.empty?
		state = :pending
		moderation = self.build_moderation
		moderation.reason = reason
		moderation.state = state
		write_attribute(:moderation_state, state)
		moderation.moderation_state_changes.build({:state => state, :reason => reason})
		moderation_field_change = moderation.moderation_field_changes.build
		moderated_fields.each do |f|
			value = self[f]
			moderation_field_change.changed_fields[f] = value
			moderation.changed_fields[f] = value
		end
		moderation.save
		self.save
	end

end

