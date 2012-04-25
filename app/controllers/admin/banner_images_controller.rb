# coding: utf-8

class Admin::BannerImagesController < Admin::BaseController
	before_filter :find_advert

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
		redirect_to user_offer_advert_path(@user, @offer, @advert)
	end

	def destroy
		@banner_image = @advert.banner_images.find(params[:id])
		flash[:notice] = 'Изображение удалено.' if @banner_image.destroy
		redirect_to user_offer_advert_path(@user, @offer, @advert)
	end

	private

	def find_advert
		@user = User.find(params[:user_id])
		@offer = @user.offers.find(params[:offer_id])
		@advert = @offer.adverts.find(params[:advert_id])
	end
	
end
