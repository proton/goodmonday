class GroundRotatorConfig
  include Mongoid::Document
	embedded_in :ground

	#has_and_belongs_to_many :categories
	field :categories_ids, type: Array, default: []

	field :block_adult, type: Boolean, default: true
	field :block_doubtful, type: Boolean, default: true

	def categories
		self.categories_ids
	end

	def categories= (ids)
		self.categories_ids = ids.reject(&:blank?)
	end

end
