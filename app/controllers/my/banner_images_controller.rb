# coding: utf-8

class My::BannerImagesController < My::BaseController
	before_filter :find_advert

	def find_advert
		@offer = current_user.offers.find(params[:offer_id])
		@advert = @offer.adverts.find(params[:advert_id])
	end

	def create
		@banner_image = @advert.banner_images.build(params[:banner_image])
		#if @banner_image.valid?
		#	flash[:notice] = 'valid'
		#else
		#	flash[:error] = 'invalid'
		#end
		if @banner_image.save
			flash[:notice] = 'Изображение добавлено.'
		else
			flash[:error] = @banner_image.errors.messages[:size] ? 'Неверный размер изображения' : @banner_image.errors.full_messages
		end
		redirect_to my_offer_advert_path(@offer, @advert)
		#respond_with(@banner_image, :location => my_offer_advert_path(@offer, @advert))
	end

	def destroy
		@banner_image = @advert.banner_images.find(params[:id])
		flash[:notice] = 'Изображение удалено.' if @banner_image.destroy
		redirect_to my_offer_advert_path(@offer, @advert)
 end
	
end
