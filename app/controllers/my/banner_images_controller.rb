# coding: utf-8

class My::BannerImagesController < My::BaseController
	before_filter :find_advert

	def find_advert
		@offer = current_user.offers.find(params[:offer_id])
		@advert = @offer.adverts.find(params[:advert_id])
	end

	def create
		@banner_image = @advert.banner_images.build(params[:banner_image])
		flash[:notice] = 'Изображение добавлено.' if @banner_image.save
		redirect_to my_offer_advert_path(@offer, @advert)
	end

	def destroy
		@banner_image = @advert.banner_images.find(params[:id])
		flash[:notice] = 'Изображение удалено.' if @banner_image.destroy
		redirect_to my_offer_advert_path(@offer, @advert)
 end
	
end
