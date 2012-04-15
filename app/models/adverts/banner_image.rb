class BannerImage
	include Mongoid::Document
	include Mongoid::Symbolize
	include Mongoid::Timestamps
	embedded_in :banner

	before_save :update_advert_sizes
	before_destroy :update_advert_sizes

	symbolize :size, :in => ADVERTS_SIZES

	field :auto_generated, type: Boolean, default: false
	mount_uploader :image, BannerImageUploader

	#validate :check_dimensions
	#
	#def check_dimensions
	##	::Rails.logger.info "Avatar upload dimensions: #{self.avatar_upload_width}x#{self.avatar_upload_height}"
	##	errors.add :avatar, "Dimensions of uploaded avatar should be not less than 150x150 pixels." if self.avatar_upload_width < 150 || avatar_upload_height < 150
	#	true
	#end

	MODERATED_ATTRS = %w[image]
	MODERATED_ATTRS_INFO = {'image' => {:type => :carrierwave_image} }
	include IsModerated

	def update_advert_sizes
		self.banner.update_sizes
	end
end
