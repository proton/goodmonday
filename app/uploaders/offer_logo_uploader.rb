# encoding: utf-8

class OfferLogoUploader < CarrierWave::Uploader::Base
	include CarrierWave::MiniMagick

	def extension_white_list
  	%w(jpg jpeg gif png)
	end

  storage :fog if Rails.env.production?

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
	end

  process :resize_to_fit => [200, 100]

end
