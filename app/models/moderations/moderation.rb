class Moderation
	include Mongoid::Document
	include Mongoid::Symbolize
	include Mongoid::Timestamps

	#before_create :add_initial_state_change

	belongs_to :moderated, polymorphic: true
	embeds_many :moderation_field_changes
	embeds_many :moderation_state_changes

	symbolize :state, :in => [:accepted, :denied, :pending], :scopes => true, :default => :pending
	symbolize :reason, :in => [:created, :updated], :default => :created
	field :moderated_type, type: String, default: -> { self.moderated.class.to_s }
	field :changed_fields, type: Hash, default: {}
	field :accepted_fields, type: Hash, default: {}
	field :moderated_path, type: String

	def accept(current_user, edit_fields = nil)
		state = :accepted
		self.state = state
		self.moderation_state_changes.build({:state => state, :reason => :checked, :user => current_user, :edit_fields => edit_fields})
		self.accepted_fields.merge! self.changed_fields
		self.changed_fields.clear
		self.save
		m_obj = moderated_object
		if edit_fields && !edit_fields.empty?
			edit_fields.each do |key, value|
				m_obj.send("#{key}=", value)
			end
		end
		m_obj.write_attribute(:moderated_state, state)
		m_obj.save
	end

	def deny(current_user)
		state = :denied
		self.state = state
		self.moderation_state_changes.build({:state => state, :reason => :checked, :user => current_user})
		self.save
		moderated_object.update_attribute(:moderated_state, state)
	end

	def moderated_object
		if self.moderated_path
      begin
			  eval(self.moderated_path)
      rescue Exception
        nil
      end
		else
			moderated
		end
	end
end