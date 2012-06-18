module IsModerated
	extend ActiveSupport::Concern

	included do
		has_one :moderation, as: :moderated, dependent: :delete
		field :moderated_state, type: Symbol, default: :pending
		after_create :add_moderation
		before_update{ @changed_attrs = changes.clone }
		after_update :set_moderation

		scope :accepted, where(:moderated_state => :accepted)
		scope :denied,	 where(:moderated_state => :denied)
		scope :pending,  where(:moderated_state => :pending)
	end

	module ClassMethods
		def moderated_fields
			MODERATED_ATTRS
		end
	end

	def add_moderation
		moderated_fields = self.class::MODERATED_ATTRS
		change_moderation moderated_fields, :created
  end

	def set_moderation
		return if @changed_attrs.has_key? 'moderated_state' #не достаточно, если уже :pending не помогает, надо проверять, что с модерациями
		moderated_fields = @changed_attrs.keys & self.class::MODERATED_ATTRS
		change_moderation moderated_fields, :updated
	end

	def change_moderation(moderated_fields, reason)
		return if moderated_fields.empty?
		state = :pending
    unless self.moderated_state==state
      self.update(moderated_state: state)
    end
		moderation = self.moderation
		unless moderation
			moderation = self.build_moderation
			if self.embedded?
				moderation.moderated_path = generate_moderated_path
			end
    end
		moderation.reason = reason
		moderation.state = state
		moderation.moderation_state_changes.build({:state => state, :reason => reason})
		moderation_field_change = moderation.moderation_field_changes.build
		moderated_fields.each do |f|
			value = self[f]
			moderation_field_change.changed_fields[f] = value
			moderation.changed_fields[f] = value
		end
		moderation.save
	end

	def generate_moderated_path
		path = ''
		obj = self
		while obj.embedded?
			model_name = obj.atomic_path.split('.').last
			if self.embedded_one?
				path = ".#{model_name}#{path}"
			else
				path = ".#{model_name}.find('#{obj._id}')#{path}"
			end
			obj = obj._parent
		end
		path = "#{obj.class}.find('#{obj._id}')#{path}"
		path
	end

	def is_accepted?
		self.moderated_state == :accepted
	end

	def is_denied?
		self.moderated_state == :denied
	end

	def is_pending?
		self.moderated_state == :pending
	end

end

