class BannerImage
	include Mongoid::Document
	include Mongoid::Symbolize
	include Mongoid::Timestamps
	embedded_in :banner

	symbolize :size, :in => ADVERTS_SIZES

	field :auto_generated, type: Boolean, default: false
	mount_uploader :image, BannerImageUploader, mount_on: :image_filename

	MODERATED_ATTRS = [:image_filename]
	MODERATED_ATTRS_INFO = {'image_filename' => {:type => :carrierwave_image, :show_method => 'image'} }
	include IsModerated
end
