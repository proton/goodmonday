# encoding: utf-8

class BannerImageUploader < CarrierWave::Uploader::Base
	include CarrierWave::MiniMagick

	def extension_white_list
  	%w(jpg jpeg gif png)
	end

  storage :fog

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



  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
