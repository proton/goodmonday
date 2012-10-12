# encoding: utf-8

class BannerImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

	def extension_white_list
  	%w(jpg jpeg gif png)
	end

  storage :fog if Rails.env.production?

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
	end

	process :get_dimensions

	def get_dimensions
		#image = ::MiniMagick::Image::read(@file.file).first
		image = ::MiniMagick::Image.open(current_path)
		if model
			width = image[:width]
			height = image[:height]
			model.size = "#{width}x#{height}"
		end
	end

end
