# coding: utf-8

class My::BannerImagesController < My::BaseController
	inherit_resources
	before_filter :find_advert

	def find_advert
		@offer = current_user.offers.find(params[:offer_id])
		@advert = @offer.adverts.find(params[:advert_id])
	end

	def create
		@banner_image = @advert.banner_images.build(params[:banner_image])

		respond_to do |format|
			if @banner_image.save
				format.html  { redirect_to(my_offer_advert_path(@offer, @advert), :notice => 'Изображение добавлено.') }
			else
				format.html  { redirect_to(my_offer_advert_path(@offer, @advert)) }
			end
		end
	end

	def destroy
		@banner_image = @advert.banner_images.find(params[:id])
		@banner_image.destroy
		redirect_to(my_offer_advert_path(@offer, @advert), :notice => 'Изображение удалено.')
 end

	#def update
	#	@offer = Offer.find(params[:id])
	#
	#  respond_to do |format|
	#    if @offer.update_attributes(params[:offer])
	#      format.html  { redirect_to(my_offer_path(@offer), :notice => 'Оффер успешно обновлен.') }
	#    else
	#      format.html  { render :action => "edit" }
	#    end
	#  end
	#end
	
end
