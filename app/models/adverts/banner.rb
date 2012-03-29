class Banner < Advert
	field :url, type: String

	embeds_many :banner_images

	MODERATED_ATTRS = [:url]
	include IsModerated
end
