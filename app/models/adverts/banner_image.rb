class BannerImage
	include Mongoid::Document
	include Mongoid::Symbolize
	include Mongoid::Timestamps
	embedded_in :banner

	symbolize :size, :in => ADVERTS_SIZES

	field :auto_generated, type: Boolean, default: false
	mount_uploader :image, BannerImageUploader

	MODERATED_ATTRS = [:image]
	MODERATED_ATTRS_INFO = {'image' => {:type => :carrierwave_image} }
	include IsModerated
end
