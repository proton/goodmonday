class Banner < Advert
	field :url, type: String

	embeds_many :banner_images

	MODERATED_ATTRS = [:url]
	include IsModerated

	def update_sizes
		self.sizes = self.banner_images.accepted.collect{|a| a.size}.flatten.compact
		self.save
	end

	def html_code(size)
		banner_image = banner_images.where(:size => size.to_sym).first
		"<a href='#{self.url}'><img src='#{banner_image.image}' /></a>"
	end
end
