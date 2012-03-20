class ModerationFieldChange
	include Mongoid::Document

	embedded_in :moderation

	field :changed_fields, type: Hash, default: {}
	field :created_at, type: DateTime, default: -> { DateTime.now }
end
