class Banner < Advert
	field :url, type: String

	embeds_many :banner_images
end
