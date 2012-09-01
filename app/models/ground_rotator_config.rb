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

  def offers
    ret = Offer.all
    ret = ret.where(:is_adult => false) if self.block_adult
    ret = ret.where(:is_doubtful => false) if self.block_doubtful
    ret = ret.any_in(categories_ids: self.categories_ids) unless categories.empty?
    ret
  end

end
