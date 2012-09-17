# coding: utf-8

class Banner < Advert
  field :url, type: String
  field :description, type: String

	embeds_many :banner_images

	MODERATED_ATTRS = [:url]
	include IsModerated

	def update_sizes
		self.sizes = self.banner_images.accepted.collect{|a| a.size}.flatten.compact
		self.save
	end

	def html_code(size, ground)
		banner_image = banner_images.where(:size => size.to_sym).first
    #"<a href='#{self.url}'><img src='#{banner_image.image}' /></a>"
    "<a href='http://r.goodmonday.ru/#{ground.id}/goto/#{offer.id}/#{self.id}'><img src='#{banner_image.image}' /></a>"
	end
end
