# coding: utf-8

class BannerImage
	include Mongoid::Document
	include Mongoid::Symbolize
	include Mongoid::Timestamps
	embedded_in :banner

	after_save :update_advert_sizes
	before_destroy :update_advert_sizes

  symbolize :size, :in => ADVERTS_SIZES

	field :auto_generated, type: Boolean, default: false
  attr_accessible :image
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
    true
  end

  include Rails.application.routes.url_helpers
  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    advert = banner
    offer = advert.offer
    #user_id = offer.advertiser_id
    {
    "id" => read_attribute(:_id),
    "name" => read_attribute(:image),
    "size" => read_attribute(:size),
    'moderated_state' => read_attribute(:moderated_state),
    "url" => image.url,
    #"delete_url" => user_offer_advert_banner_image_path(user_id, offer, advert, id),
    "delete_url" => offer_advert_banner_image_path(offer, advert, id),
    "delete_type" => "DELETE"
  }
  end
end
